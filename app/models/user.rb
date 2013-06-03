class User < ActiveRecord::Base

  WELCOME_PROGRAM_START_DATE = (ENV['WELCOME_PROGRAM_START_DATE'] ? Date.parse(ENV['WELCOME_PROGRAM_START_DATE']) : nil) || (Date.today - 1.month)

  self.per_page = 5

  attr_accessor :current_pass
  acts_as_authentic do |t|
    t.ignore_blank_passwords = true;
    t.merge_validates_length_of_password_field_options :minimum =>6, :maximum =>24
  end

  validates :last_name, :presence => true

  disable_perishable_token_maintenance(true)

  has_one :user_option, :autosave => true
  has_many :user_emails, :autosave => true
  has_many :user_actions, :autosave => true

  has_many :relations, :autosave => true, :dependent => :destroy
  has_many :invites, :class_name => 'Relation', :foreign_key => :inviter_id, :dependent => :nullify

  has_many :accessible_relations, :class_name => 'Relation', :conditions => ["relations.access = ? AND accepted = ? ", true, 1]
  has_many :all_children, :through => :relations, :source => :child
  has_many :children, :through => :accessible_relations, :source => :child
  has_many :own_children, :through => :accessible_relations, :conditions => {"relations.is_admin" => true}, :source => :child
  has_many :very_own_children, :through => :accessible_relations, :conditions => ["relations.is_admin = ? AND (relations.is_family_admin = ? OR relations.member_type = ? OR relations.member_type = ?)", true, true, "Father", "Mother"], :source => :child
  has_many :other_children, :through => :accessible_relations, :conditions => {"relations.is_admin" => false}, :source => :child
  has_many :families, :through => :children, :source => :family,:uniq => true
  has_many :own_families, :through => :own_children, :source => :family, :uniq => true
  has_many :very_own_families, :through => :very_own_children, :source => :family, :uniq => true
  has_many :other_families, :through => :other_children, :source => :family, :uniq => true
  
  has_many :media, :class_name => "Media"  
  has_one :attachment, :as => :object, :dependent => :destroy
  has_one :profile_media, :through => :attachment, :source => :media
  
  has_many :timeline_entries, :dependent => :destroy
  has_many :logs

  before_create :add_options
  
  scope :ids, select("users.id")

  #===================================================#
  #===== REMOVE USER WITH ALL ASSOCIATED DATA ======= #
  #===================================================#
  def destroy_user
    self.own_children.each do |child|
      unless child.admins.where(["relations.user_id != ?", self.id]).any?
        child.destroy_child
      end
    end
    self.destroy
  end


  #=====================#
  #===== EMAILS ======= #
  #=====================#
  def self.subscribed
    joins(:user_option).includes(:user_option).where(['user_options.subscribed = ?', true])
  end

  def self.welcome_program_disabled
    joins(:user_option).includes(:user_option).where(['user_options.is_welcome_program_enabled = ?', false])
  end
  
  def self.with_email title, count
    subscribed.joins(:user_emails).where(["user_emails.title = ? AND user_emails.count = ?", title, count])
  end  

  def self.without_email title
    subscribed.where(["NOT EXISTS(SELECT 1 FROM user_emails ue WHERE ue.user_id = users.id AND ue.title = ?)", title])
  end

  def self.with_email_updated_later_than title, last_updated    
    subscribed.joins(:user_emails).where(["user_emails.title = ? AND user_emails.updated_at <= ?", title, last_updated]).uniq
  end
  
  def self.inactive_from_to date_one, date_two
    where(["users.last_request_at < ? AND users.last_request_at >= ?", date_one, date_two])
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
    date = DateTime.now - 7.days  if frequency == 'weekly'
    date = DateTime.now - 1.days  if frequency == 'daily'
    date = DateTime.now - 1.months  if frequency == 'monthly'

    return date
  end
  # => Queries for newsletters


  def self.with_actions include_action, exclude_action, no_older_than
    users = UserAction.not_older_than(no_older_than).includes(:user => :user_option).find_all_by_title(include_action).map{|ua| ua.user}
    users.delete_if { |u| u.user_option.subscribed == false || u.user_actions.exists?(:title => exclude_action) }
 
    return users
  end

  def self.with_and_without_action include_actions, exclude_actions, no_older_than, not_newer_than = Date.today, additional_user_conditions = ""
    include_users = []
    include_actions.each do |action_title|
      if no_older_than
        include_users += UserAction.not_older_than(no_older_than).not_newer_than(not_newer_than).find_all_by_title(action_title, :select => "user_id").map(&:user_id)
      else
        include_users += UserAction.find_all_by_title(action_title, :select => "user_id").map(&:user_id)
      end
    end

    exclude_users = []
    exclude_actions.each do |action_title|
      exclude_users += UserAction.find_all_by_title(action_title, :select => "user_id").map(&:user_id)
    end
    
    user_ids = include_users - exclude_users
    
    User.find_all_by_id(user_ids, :conditions => additional_user_conditions, :include => [:user_option])
  end

  def self.with_and_without_action_subscribers include_actions, exclude_actions, no_older_than, not_newer_than = Date.today
    self.with_and_without_action include_actions, exclude_actions, no_older_than, not_newer_than, ["user_options.subscribed = ?", true]
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
      child = user_action.child || self.own_children.first

      behaviour = Behaviour.includes(:activities).find_by_category('L', :conditions => ["behaviours.age_from <= ? ", child.months_old], :order => 'behaviours.age_from DESC')      
      user_email = UserEmail.find_or_initialize_by_user_id_and_title(self.id, 'child_added' )

      if user_email.new_record? && behaviour
        UserMailer.step_3_pending(self, child, behaviour).deliver
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
      child = user.own_children.first
      question = child.get_first_answered_question      
      
      if question
        UserMailer.registration_completed(user, child, question).deliver
        ue = user.user_emails.find_by_user_id_and_title(user.id, 'initial_questionnaire_completed')
        ue.update_attributes(:updated_at => DateTime.now)
      end
    end
  end

  def self.select_users_for_newsletter
    users = []
    users += User.welcome_program_disabled.subscribed.with_email_title_for_frequency 'newsletter', 'weekly'
    users += User.welcome_program_disabled.subscribed.with_email_title_for_frequency 'newsletter', 'daily'
    users += User.welcome_program_disabled.subscribed.with_email_title_for_frequency 'newsletter', 'monthly'

    users += User.welcome_program_disabled.subscribed.without_newsletter_email_for_frequency 'weekly'
    users += User.welcome_program_disabled.subscribed.without_newsletter_email_for_frequency 'daily'
    users += User.welcome_program_disabled.subscribed.without_newsletter_email_for_frequency 'monthly'
    
    return users
  end

  def self.send_newsletters
    users = User.select_users_for_newsletter

    users.each do |user|
      user.own_children.each do |child|
        if child.seen_behaviours.any?
          email = user.user_emails.find_or_initialize_by_title_and_child_id('newsletter', child.id)
          current_category = email.description unless email.new_record?

          behaviour = child.get_next_category_behaviour(user, current_category)
          if behaviour
            next_two_behaviours = []
            next_two_behaviours = Behaviour.get_next_2_behaviours_for_category(behaviour.category, behaviour.age_from)

              UserMailer.newsletter(user, child, behaviour, next_two_behaviours).deliver
              email.update_attributes(:description => behaviour.category,  :updated_at => DateTime.now)
          end
        end
      end
    end
  end

  def self.send_inactive
    users = User.select_inactive_users

    users.each do |user|
      child = user.own_children.first
      if child
        UserMailer.inactive(user, child).deliver
        user.send_email!('inactive', :updated_at => DateTime.now)
      end
    end
  end
  #=====================#
  #===== EMAILS ======= #
  #=====================#


  
  def get_user_name
    if first_name.blank?
      return email.split('@').first.capitalize unless email.blank?      
    else
      return first_name.capitalize + " " + last_name.capitalize
    end    
    return ''
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


  def select_first_family
    family = self.very_own_families.first if self.very_own_families.any?
    family = self.own_families.first if family.nil? && self.own_families.any?
    family = self.other_families.first if family.nil? && self.other_families.any?

    return family
  end

  def get_first_very_own_family
    result = nil
    if self.very_own_families.any?
       result = self.very_own_families.where(["relations.inviter_id IS NULL"]).first
       result = self.very_own_families.first unless result
    end

    return result
  end

  def create_initial_actions_and_emails child
    self.user_actions.find_or_create_by_title('initial_questionnaire_completed')    
    self.user_actions.find_or_create_by_title("account_created")

    if !self.user_emails.find_by_title('initial_questionnaire_completed')
      @behaviours = child.max_seen_by_category
      
      UserMailer.registration_completed(self, child, @behaviours.first).deliver if self.user_option.subscribed
      self.user_emails.create(:title => 'initial_questionnaire_completed')
    end
    
  end

  def self.send_welcome_program_emails
    self.send_welcome_email
    self.send_day_1_email
  end

  def self.send_welcome_email
    include_actions = ['initial_questionnaire_completed', "account_created"]
    exclude_actions = [ UserAction::ACTIONS["WELCOME_PROGRAM_INITIAL_EMAIL"] ]
    @welcome_email_users = User.with_and_without_action_subscribers( include_actions, exclude_actions, User::WELCOME_PROGRAM_START_DATE)
    
    @welcome_email_users.each do |user|      
      user.user_option.is_welcome_program_enabled = true
      user.user_option.save 

      user_action = UserAction.find_by_user_id_and_title(user.id, 'child_added')
      
      child = user_action ? user_action.child : user.own_children.first        
      
      if child
        max_seen = nil
        Behaviour::CATEGORIES_ORDER.each do |key|
          max_seen = child.behaviours.max_for_category(key).first if !max_seen
        end
        
        if max_seen
          WelcomeProgramMailer.welcome_email(user, child, max_seen).deliver
          user.user_actions.find_or_create_by_title(UserAction::ACTIONS["WELCOME_PROGRAM_INITIAL_EMAIL"])
        end
      end
    end
  end

  def self.send_day_1_email
    include_actions = [ UserAction::ACTIONS["WELCOME_PROGRAM_INITIAL_EMAIL"] ]
    exclude_actions = [ UserAction::ACTIONS["WELCOME_PROGRAM_DAY_1_EMAIL"] ]
    @day_1_users = User.with_and_without_action_subscribers(include_actions, exclude_actions, Date.today - 1.month, Date.today - 1.day)
    
    @day_1_users.each do |user|
      user_action = UserAction.find_by_user_id_and_title(user.id, 'child_added')
      
      child = user_action ? user_action.child : user.own_children.first        
      
      if child
        WelcomeProgramMailer.day_1_email(user, child).deliver 
        user.user_actions.find_or_create_by_title(UserAction::ACTIONS["WELCOME_PROGRAM_DAY_1_EMAIL"])
      end
    end
  end

  def self.send_day_2_email
    include_actions = [ UserAction::ACTIONS["WELCOME_PROGRAM_DAY_1_EMAIL"] ]
    exclude_actions = [ UserAction::ACTIONS["WELCOME_PROGRAM_DAY_2_EMAIL"] ]
    @day_2_users = User.with_and_without_action_subscribers(include_actions, exclude_actions, Date.today - 1.month, Date.today - 1.day)
    
    @day_2_users.each do |user|
      user_action = UserAction.find_by_user_id_and_title(user.id, 'child_added')
      
      child = user_action ? user_action.child : user.own_children.first        
      
      if child
        WelcomeProgramMailer.day_2_email(user, child).deliver
        user.user_actions.find_or_create_by_title(UserAction::ACTIONS["WELCOME_PROGRAM_DAY_2_EMAIL"])
      end
    end
  end

  def self.send_day_3_email
    include_actions = [ UserAction::ACTIONS["WELCOME_PROGRAM_DAY_2_EMAIL"] ]
    exclude_actions = [ UserAction::ACTIONS["WELCOME_PROGRAM_DAY_3_EMAIL"] ]
    @day_3_users = User.with_and_without_action_subscribers(include_actions, exclude_actions, Date.today - 1.month, Date.today - 1.day)
    
    @day_3_users.each do |user|
      user_action = UserAction.find_by_user_id_and_title(user.id, 'child_added')
      
      child = user_action ? user_action.child : user.own_children.first        
      
      if child
        behaviour = @child.behaviours.max_for_category("L").first

        if behaviour
          WelcomeProgramMailer.day_3_email(user, child, behaviour).deliver
          user.user_actions.find_or_create_by_title(UserAction::ACTIONS["WELCOME_PROGRAM_DAY_3_EMAIL"])
        end
      end
    end
  end

  def self.send_intelligence_email include_actions, exclude_actions, category, mark_action
    @users = User.with_and_without_action_subscribers(include_actions, exclude_actions, Date.today - 1.month, Date.today - 1.day)
    
    @users.each do |user|
      user_action = UserAction.find_by_user_id_and_title(user.id, 'child_added')
      child = user_action ? user_action.child : user.own_children.first
      
      if child
        @behaviour = child.behaviours.max_for_category(category).first 
        
        if behaviour
          WelcomeProgramMailer.day_4_email(user, child, @max_seen).deliver          
        end
        user.user_actions.find_or_create_by_title(mark_action)
      end
    end
  end

  def self.send_day_4_email
    self.send_intelligence_email [ UserAction::ACTIONS["WELCOME_PROGRAM_DAY_3_EMAIL"] ], [ UserAction::ACTIONS["WELCOME_PROGRAM_LANGUAGE_EMAIL"] ], "L", UserAction::ACTIONS["WELCOME_PROGRAM_LANGUAGE_EMAIL"]
  end


  def self.send_day_5_email
    self.send_intelligence_email [ UserAction::ACTIONS["WELCOME_PROGRAM_LANGUAGE_EMAIL"] ], [ UserAction::ACTIONS["WELCOME_PROGRAM_LOGIC_EMAIL"] ], "N", UserAction::ACTIONS["WELCOME_PROGRAM_LOGIC_EMAIL"]
  end

  def self.send_day_6_email
    self.send_intelligence_email [ UserAction::ACTIONS["WELCOME_PROGRAM_LOGIC_EMAIL"] ], [ UserAction::ACTIONS["WELCOME_PROGRAM_SOCIAL_EMAIL"] ], "L", UserAction::ACTIONS["WELCOME_PROGRAM_SOCIAL_EMAIL"]
  end

  def self.send_day_7_email
    self.send_intelligence_email [ UserAction::ACTIONS["WELCOME_PROGRAM_SOCIAL_EMAIL"] ], [ UserAction::ACTIONS["WELCOME_PROGRAM_VISUAL_EMAIL"] ], "L", UserAction::ACTIONS["WELCOME_PROGRAM_VISUAL_EMAIL"]
  end

  def self.send_day_8_email
    self.send_intelligence_email [ UserAction::ACTIONS["WELCOME_PROGRAM_VISUAL_EMAIL"] ], [ UserAction::ACTIONS["WELCOME_PROGRAM_MOVEMENT_EMAIL"] ], "L", UserAction::ACTIONS["WELCOME_PROGRAM_MOVEMENT_EMAIL"]
  end

  def self.send_day_9_email
    self.send_intelligence_email [ UserAction::ACTIONS["WELCOME_PROGRAM_MOVEMENT_EMAIL"] ], [ UserAction::ACTIONS["WELCOME_PROGRAM_EMOTIONAL_EMAIL"] ], "L", UserAction::ACTIONS["WELCOME_PROGRAM_EMOTIONAL_EMAIL"]

    user.user_option.is_welcome_program_enabled = false
    user.user_option.save 
  end

  private
  def add_options
    self.build_user_option
  end

end
