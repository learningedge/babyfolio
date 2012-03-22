class Moment < ActiveRecord::Base

  has_many :attachments, :as => :object
  has_many :media, :through => :attachments
  belongs_to :child
   

end
