class Moment < ActiveRecord::Base

  self.per_page = 6

  validates :title, :presence => true

  has_many :attachments, :as => :object
  has_many :media, :through => :attachments
  belongs_to :child
  has_and_belongs_to_many :moment_tags  


end
