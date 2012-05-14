class Moment < ActiveRecord::Base

  self.per_page = 6

#  validates :title, :presence => true
  
  has_many :attachments, :as => :object
  has_many :media, :through => :attachments
  belongs_to :child
  belongs_to :user
  
  has_many :relation_moment_tags, :class_name => "MomentTagsMoments", :order => :moment_tag_id
  accepts_nested_attributes_for :relation_moment_tags
  has_many :moment_tags, :through => :relation_moment_tags

  scope :ids, select(:id)

  VISIBILITY = {
    "Public" => "public",
    "Family & Friends only" => "family_and_friends_only",
    "Me only" => "me_only"
  }

end
