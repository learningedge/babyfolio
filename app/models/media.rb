class Media < ActiveRecord::Base

  has_many :attachments
  #has_many :moments, :thought => :attachments

  has_attached_file :image, :styles => { :thumbnail => '100x100' }

end
