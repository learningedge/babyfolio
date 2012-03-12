class User < ActiveRecord::Base    
  acts_as_authentic do |t|
    t.ignore_blank_passwords = true;
  end
  disable_perishable_token_maintenance(true)


  has_attached_file :avatar, 
    :styles => { :small => "26x26#", :medium => "93x93#" },
    :default_url => '/images/default_images/user_profile_:style.png'
  
  has_many :services
  has_many :relations
  has_many :families, :through => :relations


  def is_parent?
    !self.relations.is_parent.empty?
  end

  def main_family    
    unless self.families.parenting_families.empty?
      return self.families.parenting_families.first
    else
      return self.families.first
    end
    unless self.families.empty?
      return self.families.first
    end
  end
  
  def get_user_name
    if first_name.nil? || last_name.nil?
      return email.split('@').first.capitalize unless email.nil?
    else 
      return first_name.capitalize + " " + last_name.capitalize
    end
  end

  def first_family_with_child
    families.each do |family|
	return family if family.children.exists?
    end
    return nil
  end


# ----------- FACEBOOK -----------

  def has_facebook_account?
    @has_facebook ||= services.where(:provider => 'facebook').exists?  
  end

  def get_facebook_service
    services.where(:provider => 'facebook').first
  end

  def get_facebook_albums
    service = get_facebook_service
    @albums = FbGraph::User.fetch(service.uid, :access_token => service.token).albums
  end
  
# -------------------------------

  
end
