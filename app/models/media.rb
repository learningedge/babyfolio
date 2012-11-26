class Media < ActiveRecord::Base

  belongs_to :user
  has_one :timeline_meta, :as => :object
  has_many :attachments
  
  has_attached_file :image, :styles => { 

    :profile_tiny => "32x32#",
    :profile_small => "50x50#",
    :profile_medium => "161x155#",
    :profile_large => "320x288#",
    :attachment_large => "310x310"
  }

  def media_type
    if self.kind_of? MediaImage
      "Photo"
    elsif self.kind_of? MediaVideo
      "Video"
    end
  end

end
