class User < ActiveRecord::Base    

  self.per_page = 5

  acts_as_authentic do |t|
    t.ignore_blank_passwords = true;
  end

  disable_perishable_token_maintenance(true)

  has_many :services
  has_many :relations
  has_many :moments
  has_many :families, :through => :relations
  has_many :own_families, :through => :relations, :source => :family, :conditions => ['relations.member_type in(?)' , ['mother', 'father', 'parent']]
  has_many :own_children, :through => :own_families, :source => :children
 
  
  has_one :attachment, :as => :object
  has_one :profile_media, :through => :attachment, :source => :media

  def is_parent?
    !self.relations.is_parent.empty?
  end

  def main_family       
    return self.families.parenting_families.first unless self.families.parenting_families.empty?
    return self.families.first unless self.families.empty?
  end
  
  def get_user_name
    if first_name.nil? || last_name.nil?
      return email.split('@').first.capitalize unless email.nil?
    else 
      return first_name.capitalize + " " + last_name.capitalize
    end
  end

  def first_family_with_child
    families.accepted.each do |family|
	return family if family.children.exists?
    end
    return nil
  end

  def add_object_error(str)
    errors[:base] << str
  end


  def can_view_child? child_id
    return true
  end

  def can_edit_child? child_id
    child_id = child_id.to_i
    child_ids = (self.families.parenting_families.collect { |family| family.children.collect {|child| child.id } }).flatten
    child_ids.include?(child_id)
  end

# ----------- FACEBOOK -----------

  def has_facebook_account?
      return @has_facebook if defined?(@has_facebook)
      @has_facebook = services.where(:provider => 'facebook').exists?  
  end

  def get_facebook_service
    services.where(:provider => 'facebook').first
  end

  def get_facebook_albums
    service = get_facebook_service
    @albums = FbGraph::User.fetch(service.uid, :access_token => service.token).albums
  end

  def get_facebook_photo id
    service = get_facebook_service
    @facebook_photo = FbGraph::Photo.fetch(id, :access_token => service.token)
  end

# ---------- VIMEO --------------

  def has_vimeo_account?
    return @has_vimeo if defined?(@has_vimeo)
    @has_vimeo = services.where(:provider => 'vimeo').exists?
  end 

  def get_vimeo_service
    self.services.limit(1).find_by_provider('vimeo')
  end

  def get_vimeo_videos
    service = get_vimeo_service
    video = Vimeo::Advanced::Video.new(Yetting.vimeo["key"], Yetting.vimeo["secret"], :token => service.token, :secret => service.secret)
    video.get_all(service.uid, {:full_response => 1 })['videos']['video']    
  end

  def vimeo_client
    service = get_vimeo_service
    return @vimeo_client if defined?(@vimeo_client)
    @vimeo_client = Vimeo::Advanced::Video.new(Yetting.vimeo["key"], Yetting.vimeo["secret"], :token => service.token, :secret => service.secret)
  end

# ---------- FLICKR -------------
  def flickr_user
    return @flickr_user if defined?(@flickr_user)

    flickr_service = self.services.flickr_service.first
    unless flickr_service.nil?
      
      FlickRaw.api_key= Yetting.flickr["key"]
      FlickRaw.shared_secret= Yetting.flickr["secret"]

      flickr.access_token = self.services.flickr_service.first.token
      flickr.access_secret = self.services.flickr_service.first.secret

      @flickr_user = flickr

    end

  end

# ----------YOUTUBE -------------

  def get_youtube_service
    self.services.youtube.first
  end

  def youtube_user
    return @youtube_user if defined?(@youtube_user)

    unless self.get_youtube_service.blank?
      youtube = get_youtube_service
      @youtube_user = YouTubeIt::OAuthClient.new(
                                                 :consumer_key => Yetting.youtube["key"], 
                                                 :consumer_secret => Yetting.youtube["secret"], 
                                                 :client_id => youtube.uid, 
                                                 :dev_key => Yetting.youtube["dev_key"])
      @youtube_user.authorize_from_access(youtube.token, youtube.secret)

      return @youtube_user
    end

  end
  
# ------------------------------

end
