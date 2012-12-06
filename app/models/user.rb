class User < ActiveRecord::Base    
  self.per_page = 5

  attr_accessor :current_pass
#  attr_accessible :current_pass
  acts_as_authentic do |t|
    t.ignore_blank_passwords = true;
    t.merge_validates_length_of_password_field_options :minimum =>6, :maximum =>24
  end

  disable_perishable_token_maintenance(true)

  has_many :services
  has_many :relations, :autosave => true
  has_many :invites, :class_name => 'Relation'
  has_many :moments, :conditions => ["moments.visibility NOT IN (?)", Moment::ARCHIVED]
  has_many :children, :through => :relations, :conditions => "accepted = 1"
  has_many :all_children, :through => :relations
  has_many :logs
  has_many :media, :class_name => "Media"
  
  has_one :attachment, :as => :object
  has_one :profile_media, :through => :attachment, :source => :media
  has_many :timeline_entries, :class_name => "TimelineEntry"
  

  scope :ids, select("users.id")

  def is_parent?
    !self.relations.is_parent.empty?
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



end
