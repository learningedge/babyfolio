class Family < ActiveRecord::Base
  validates :name, :presence => true
  validates :zip_code, :presence => true

  has_many :children, :class_name => 'Child'
  has_many :relations
  has_many :users, :through => :relations

  accepts_nested_attributes_for :children, :allow_destroy => true, :reject_if => proc { |attributes| attributes['first_name'].blank? and attributes['birth_date'].blank?}
  accepts_nested_attributes_for :relations, :allow_destroy => true

  scope :parenting_family, where( :relations => { :member_type => Relation::MEMBER_TYPE[:PARENT] } )
end
