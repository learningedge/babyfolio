class Media < ActiveRecord::Base

  belongs_to :user
  
  has_attached_file :image, :styles => { 
    :thumbnail => '100x100', 
    :profile_image_small => "40x40#",
    :profile_image_medium => "93x93#",
    :profile_image_large => "228x254#"
  }


end
