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
  has_and_belongs_to_many :connected_moment_children, :class_name => "Moment", :foreign_key => "connected_parent_id", :association_foreign_key => "connected_child_id", :join_table => "moment_connections"
  has_and_belongs_to_many :connected_moment_parents, :class_name => "Moment", :foreign_key => "connected_child_id", :association_foreign_key => "connected_parent_id", :join_table => "moment_connections"


  def is_connected_with? moment_id
    @connected_moment_children ||= self.connected_moment_children.ids.collect { |moment| moment.id }
    return true if @connected_moment_children.include?(moment_id)
    @connected_moment_parents ||= self.connected_moment_parents.ids.collect { |moment| moment.id }
    return true if @connected_moment_parents.include?(moment_id)
    false
  end

  scope :ids, select("moments.id")

  VISIBILITY = {
    "Public" => "public",
    "Family & Friends only" => "family_and_friends_only",
    "Me only" => "me_only"
  }

end
