class Family < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :zip_code, :presence => true

  has_many :children, :class_name => 'Child', :autosave => true, :validate => true
  has_many :relations
  has_many :users, :through => :relations

  accepts_nested_attributes_for :children, :allow_destroy => true, :reject_if => proc { |attributes| attributes['first_name'].blank? and attributes['birth_date'].blank?}
  accepts_nested_attributes_for :relations, :allow_destroy => true

  scope :parenting_families, where( :relations => { :member_type => [Relation::MEMBER_TYPE[:PARENT], Relation::MEMBER_TYPE[:MOTHER], Relation::MEMBER_TYPE[:FATHER]] } )
  scope :accepted, where( :relations => {:accepted => true})
  

  def parents
    relations.includes(:user).where(:member_type => [Relation::MEMBER_TYPE[:PARENT], Relation::MEMBER_TYPE[:FATHER], Relation::MEMBER_TYPE[:MOTHER]]).all
  end

  def is_user_parent? user_id
    relation = relations.find_by_user_id(user_id)
    parents.include?(relation)
  end

  STEPS = ["Create Family", "Invite Family and Friends", "Add Photos/Videos"]

end
