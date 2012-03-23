class Media < ActiveRecord::Base

  belongs_to :user
  has_many :attachments
  
  has_attached_file :image, :styles => { 

    :thumbnail => '100x100', 
    
    :vsmall => "26x26#",
    :small => "40x40#",
    :medium => "93x93#",
    :moment_thumb => "120x90#",
    :large => "228x254#"
  }

  def media_type
    if self.kind_of? MediaImage
      "Photo"
    elsif self.kind_of? MediaVideo
      "Video"
    end
  end

end
