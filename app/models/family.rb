class Family < ActiveRecord::Base
  has_many :children, :class_name => 'Child'
  has_many :relations
  has_many :users, :through => :relations

  accepts_nested_attributes_for :children, :allow_destroy => true
end
