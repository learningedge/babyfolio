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
  
  scope :ids, select("users.id")
  def self.subscribed
    joins(:user_option).where(['user_options.subscribed = ?', 1])
  end
  
  def self.with_email title, count
    subscribed.where(["EXISTS(SELECT 1 FROM user_emails ue WHERE ue.user_id = users.id AND ue.title = ? AND ue.count = ?)", title, count])
  end

  def self.with_actions include_action, exclude_action
    subscribed.where(["EXISTS(SELECT 1 FROM user_actions WHERE user_actions.user_id = users.id AND user_actions.title = ?)
                      AND NOT EXISTS(SELECT 1 FROM user_actions WHERE user_actions.user_id = users.id AND user_actions.title = ?)", include_action, exclude_action ])
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

end
