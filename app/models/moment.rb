class Moment < ActiveRecord::Base

  self.per_page = 6

  has_many :attachments, :as => :object
  has_many :media, :through => :attachments
  belongs_to :child
   

end
