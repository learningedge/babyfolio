class User < ActiveRecord::Base    
  self.per_page = 5

  attr_accessor :current_pass
  acts_as_authentic do |t|
    t.ignore_blank_passwords = true;
    t.merge_validates_length_of_password_field_options :minimum =>6, :maximum =>24
  end

  disable_perishable_token_maintenance(true)

  has_one :user_option, :autosave => true
  has_many :user_emails, :autosave => true
  has_many :user_actions, :autosave => true

  has_many :relations, :autosave => true
  has_many :invites, :class_name => 'Relation'
  has_many :children, :through => :relations, :conditions => "relations.accepted = 1"
  has_many :my_children, :through => :relations, :conditions => ["relations.is_admin = ?", true], :source => :child
  has_many :all_children, :through => :relations
  has_many :logs
  has_many :media, :class_name => "Media"
  
  has_one :attachment, :as => :object
  has_one :profile_media, :through => :attachment, :source => :media
  has_many :timeline_entries, :class_name => "TimelineEntry"

  before_create :add_options
  
  scope :ids, select("users.id")
  def self.subscribed
    joins(:user_option).includes(:user_option).where(['user_options.subscribed = ?', true])
  end
  
  def self.with_email title, count
    subscribed.where(["EXISTS(SELECT 1 FROM user_emails ue WHERE ue.user_id = users.id AND ue.title = ? AND ue.count = ?)", title, count])
  end  

  def self.without_email title
    subscribed.where(["NOT EXISTS(SELECT 1 FROM user_emails ue WHERE ue.user_id = users.id AND ue.title = ?)", title])
  end

  def self.with_email_updated_later_than title, last_updated
    subscribed.where(["EXISTS(SELECT 1 FROM user_emails ue WHERE ue.user_id = users.id AND ue.title = ? AND ue.updated_at <= ?)", title, last_updated])
  end
  
  def self.inactive_from_to date_one, date_two
    subscribed.where(["users.last_login_at < ? AND users.last_login_at >= ?", date_one, date_two])
  end

  def self.select_inactive_users
    users = []
    users += without_email('inactive').inactive_from_to(DateTime.now - 14.days, DateTime.now - 21.days )
    users += with_email_updated_later_than('inactive', DateTime.now - 14.days).inactive_from_to(DateTime.now - 14.days, DateTime.now - 21.days )
    users += with_email_updated_later_than('inactive', DateTime.now - 7.days).inactive_from_to(DateTime.now - 21.days, DateTime.now - 28.days )
    return users
  end

  # => Queries for newsletters
  def self.with_frequency frequency
    subscribed.where(["user_options.newsletter_frequency = ?", frequency])
  end

  def self.with_email_title_for_frequency title, frequency
    date = User.date_for_frequency frequency
    with_frequency(frequency).joins(:user_emails).where(["user_emails.title = ? AND user_emails.updated_at <= ?", title, date])
  end

  def self.without_newsletter_email_for_frequency frequency
    date = User.date_for_frequency frequency
    with_frequency(frequency).without_email('newsletter').joins(:user_actions).where(["user_actions.title = ? AND user_actions.created_at <= ?", 'account_created', date])
  end

  def self.date_for_frequency frequency
    date = DateTime.now - 1.days  if frequency == 'weekly' # !!!!!!!! TO BE CHANGED BACK TO 7.days !!!!!!!!
    date = DateTime.now - 1.days  if frequency == 'daily'
    date = DateTime.now - 1.months  if frequency == 'monthly'

    return date
  end
  # => Queries for newsletters

  
  def self.with_actions include_action, exclude_action, no_older_than
    users = UserAction.no_older_than(no_older_than).includes(:user => :user_option).find_all_by_title(include_action).map{|ua| ua.user}
    users.delete_if { |u| u.user_option.subscribed == false || u.user_actions.exists?(:title => exclude_action) }
 
    return users
  end

  def self.send_step_2_pending_emails
    users = User.subscribed.with_actions('account_created', 'child_added', (DateTime.now - 3.days))
    users.each do |u|
      u.send_step_2_email
    end
  end

  def send_step_2_email
      joined_at = UserAction.find_by_user_id_and_title(self.id, 'account_created').created_at
      if joined_at.to_datetime + 30.minutes < DateTime.now
        ue = UserEmail.find_or_initialize_by_title_and_user_id('account_created', self.id )
        if ue.new_record?
          UserMailer.step_2_pending(self).deliver
          ue.save
        end
      end
  end

  def self.send_step_3_pending_emails
    users = User.subscribed.with_actions('child_added', 'initial_questionnaire_completed', (DateTime.now - 3.days))
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

  #Need to move to categories


  def self.resend_registration_completed
    users = User.subscribed.with_email('initial_questionnaire_completed', 1).where(["users.last_login_at < ?", DateTime.now - 7.days])

    users.each do |user|
      child = user.children.first
      answer = Child.get_first_answer_for_one_of_the_categories

      question = nil
      question = answer.question if answer
      if question
        UserMailer.registration_completed(user, child, question).deliver
        ue = user.user_emails.find_by_user_id_and_title(user.id, 'initial_questionnaire_completed')
        ue.update_attributes(:updated_at => DateTime.now)
      end
    end
  end

  def self.select_users_for_newsletter
    users = []
    users += User.subscribed.with_email_title_for_frequency 'newsletter', 'weekly'
    users += User.subscribed.with_email_title_for_frequency 'newsletter', 'daily'
    users += User.subscribed.with_email_title_for_frequency 'newsletter', 'monthly'

    users += User.subscribed.without_newsletter_email_for_frequency 'weekly'
    users += User.subscribed.without_newsletter_email_for_frequency 'daily'
    users += User.subscribed.without_newsletter_email_for_frequency 'monthly'
    
    return users
  end

  def self.send_newsletters
    users = User.select_users_for_newsletter

    users.each do |user|
      user.my_children.each do |child|
        if child.answers.any?
          email = user.user_emails.find_or_initialize_by_title_and_child_id('newsletter', child.id)
          current_category = email.description unless email.new_record?

          question_milestone = child.get_next_category_question_with_milestone(user, current_category)
          if question_milestone
            next_two_questions = []
            next_two_questions = Question.get_next_2_questions_for_category(question_milestone.category, question_milestone.age)
            milestone_one = next_two_questions[0].milestone if next_two_questions.length > 0
            milestone_two = next_two_questions[1].milestone if next_two_questions.length > 1

            if question_milestone.milestone
              UserMailer.newsletter(user, child, question_milestone, milestone_one , milestone_two).deliver
              email.update_attributes(:description => question_milestone.category,  :updated_at => DateTime.now)
            end
          end
        end
      end
    end
  end

  def self.send_inactive
    users = User.select_inactive_users

    users.each do |user|
      child = user.my_children.first
      if child
        UserMailer.inactive user, child
        user.send_email!('inactive', :updated_at => DateTime.now)
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

  def do_action! action, attributes = {}
    self.user_actions.find_or_create_by_title(action, attributes)
  end

  def get_email title
    self.user_emails.find_by_title(title)
#    self.user_emails.exists?(:title => title)
  end

  def send_email! title, attributes = {}
    email = self.user_emails.find_or_initialize_by_title(title)
    email.update_attributes(attributes) unless attributes.empty?
    return email    
  end




  private
  def add_options
    self.build_user_option
  end

end
