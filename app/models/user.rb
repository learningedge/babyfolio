class User < ActiveRecord::Base    
  self.per_page = 5

  attr_accessor :current_pass
  acts_as_authentic do |t|
    t.ignore_blank_passwords = true;
    t.merge_validates_length_of_password_field_options :minimum =>6, :maximum =>24
  end

  disable_perishable_token_maintenance(true)

  has_one :user_option, :autosave => true
  has_many :user_emails
  has_many :user_actions, :autosave => true

  has_many :relations, :autosave => true
  has_many :invites, :class_name => 'Relation'
  has_many :children, :through => :relations, :conditions => "accepted = 1"
  has_many :all_children, :through => :relations
  has_many :logs
  has_many :media, :class_name => "Media"
  
  has_one :attachment, :as => :object
  has_one :profile_media, :through => :attachment, :source => :media
  has_many :timeline_entries, :class_name => "TimelineEntry"

  before_create :add_options
  
  scope :ids, select("users.id")
  def self.subscribed
    joins(:user_option).where(['user_options.subscribed = ?', 1])
  end
  
  def self.with_email title, count
    subscribed.where(["EXISTS(SELECT 1 FROM user_emails ue WHERE ue.user_id = users.id AND ue.title = ? AND ue.count = ?)", title, count])
  end

  # Need to be changed
  def self.with_actions include_action, exclude_action
    actions = UserAction.where({:title => include_action })
    exclude = UserAction.where({:title => exclude_action })
    users = (actions - exclude).map { |a| a.user(:include => :user_option) }
    users.delete_if { |u| u.user_option.subscribed == false }
 
    return users

    # subscribed.where(["EXISTS(SELECT 1 FROM user_actions WHERE user_actions.user_id = users.id AND user_actions.title = ?)
#                      AND NOT EXISTS(SELECT 1 FROM user_actions WHERE user_actions.user_id = users.id AND user_actions.title = ?)", include_action, exclude_action ])
  end

  def self.send_step_2_pending_emails
    users = User.subscribed.with_actions('account_created', 'child_added')
    users.each do |u|
      u.send_step_2_email
    end
  end

  def send_step_2_email
      joined_at = UserAction.find_by_user_id_and_title(self.id, 'account_created').created_at
      if (DateTime.now - joined_at.to_datetime).to_f * 24 * 60 >= 30
        ue = UserEmail.find_or_initialize_by_user_id_and_title(self.id, 'account_created' )
        if ue.new_record?
          UserMailer.step_2_pending(self).deliver
          ue.save
        end
      end
  end

  def self.send_step_3_pending_emails
    users = User.subscribed.with_actions('child_added', 'initial_questionnaire_completed')
    users.each do |u|
      u.send_step_3_email
    end
  end

  def send_step_3_email
    user_action = UserAction.find_by_user_id_and_title(self.id, 'child_added')
    if user_action && (user_action.created_at + 30.minutes < DateTime.now)
      child = user_action.child || self.children.first

      question = Question.includes(:milestone).find_by_category('l', :conditions => ["questions.age <= ? ", child.months_old], :order => 'questions.age DESC')
      milestone = question.milestone if question

      user_email = UserEmail.find_or_initialize_by_user_id_and_title(self.id, 'child_added' )

      if user_email.new_record? && milestone
        UserMailer.step_3_pending(self, child, milestone).deliver
        user_email.save
        return true
      end
    end

    return false
  end

  def self.resend_registration_completed
    users = User.subscribed.with_email('initial_questionnaire_completed', 1).where(["users.last_login_at < DATE(?)", DateTime.now - 7.days])
    users.each do |u|
        c = u.children.first
        a = nil
        Question::CATS_ORDER.each do |c|
          a = c.answers.includes([:question => :milestone]).where(["questions.category = ?", c]).order('questions.age DESC').limit(1).first.question
          break unless a.nil?
        end
        q = a.question
        if q
            UserMailer.registration_completed(u, c, q).deliver
            ue = u.user_emails.find_by_user_id_and_title(u.id, 'initial_questionnaire_completed')
            ue.update_attributes(:updated_at => DateTime.now)
        end
    end
  end
  
  def get_user_name
    if first_name.blank?
      return email.split('@').first.capitalize unless email.nil?
    else 
      return first_name.capitalize + " " + last_name.capitalize
    end
  end

  def get_image_src size, default = "/images/img_upload.png"
    result = self.profile_media.image.url(size) if self.profile_media.present?
    result = default if result.blank?
    result
  end

  def add_object_error(str)
    errors[:base] << str
  end

  def visited_timeline?
    timeline_visited = true
    visited_action = self.user_actions.find_or_initialize_by_title(:title => 'timeline_visited')
    if visited_action.new_record?
      timeline_visited = false
      visited_action.save
    end
    return timeline_visited
  end

  def done_action? action
    self.user_actions.exists?(:title => action)
  end

  def do_action! action
    self.user_actions.find_or_create_by_title(action)
  end




  private
  def add_options
    self.build_user_option
  end

end
