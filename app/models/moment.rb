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

  scope :ids, select("moments.id")
  ## moment widoczny jezeli:
  # - jest publiczny
  # - jest stworzony przez current usera
  # - ma status "Family & Friends only" oraz current user nalezy do rodziny
  # - jesli nie jes stworzony przez current usera ale current user jest rodzicem
  scope :can_be_viewed_by, lambda { |current_user, family| includes(:child).where([ "moments.visibility = ? OR moments.user_id = ? OR (moments.visibility = ? AND children.family_id IN (?)) OR (moments.visibility = ? AND moments.user_id IN (?))",
                                                                    Moment::VISIBILITY["Public"],
                                                                    current_user.id,
                                                                    Moment::VISIBILITY["Family & Friends only"],
                                                                    current_user.families.ids.collect{|family| family.id},
                                                                    Moment::VISIBILITY["Me only"],
                                                                    family.family_parents.ids.collect{|family| family.id}])}
                                                                    
  VISIBILITY = {
    "Public" => "public",
    "Family & Friends only" => "family_and_friends_only",
    "Me only" => "me_only"
  }
  ARCHIVED = "archived"

  attr_accessor :can_be_edited
  attr_accessor :can_be_viewed

  def can_be_viewed? current_user
    return self.can_be_viewed unless self.can_be_viewed.nil?
    return self.can_be_viewed = true if self.visibility == Moment::VISIBILITY["Public"]
    return self.can_be_viewed = true if self.user_id == current_user.id
    return self.can_be_viewed = true if self.visibility == Moment::VISIBILITY["Family & Friends only"] and ((current_user.families.ids.collect{|family| family.id}).include?(self.child.family_id))
    self.can_be_viewed = false      
  end

  def can_be_edited? current_user
    return self.can_be_edited if defined?(self.can_be_edited)
    return self.can_be_edited = true if self.user_id == current_user.id
    self.can_be_viewed = false
  end

  def is_connected_with? moment_id
    @connected_moment_children ||= self.connected_moment_children.ids.collect { |moment| moment.id }
    return true if @connected_moment_children.include?(moment_id)
#    @connected_moment_parents ||= self.connected_moment_parents.ids.collect { |moment| moment.id }
#    return true if @connected_moment_parents.include?(moment_id)
    false
  end


end
