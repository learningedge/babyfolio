class Media < ActiveRecord::Base

  belongs_to :user
  
  has_attached_file :image, :styles => { 

    :thumbnail => '100x100', 
    
    :vsmall => "26x26#",
    :small => "40x40#",
    :medium => "93x93#",
    :large => "228x254#"
  }

end
