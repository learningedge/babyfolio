class Relation < ActiveRecord::Base
  belongs_to :user
  belongs_to :family
  
  accepts_nested_attributes_for :user, :allow_destroy => true#, :reject_if => proc { |attributes| attributes['email'].blank?}

  MEMBER_TYPE = {
    :PARENT => 'parent',
    :GRANDMOTHER => 'grandmother',
    :GRANDFATHER => 'grandfather',
    :AUNT => 'aunt',
    :UNCLE => 'uncle',
    :GODMOTHER => 'godmother',
    :GODFATHER => 'godfather',
    :FRIEND => 'friend',
    :COUSIN => 'cousin',
    :GREAT_GRANDMOTHER => 'great-grandmother',
    :GREAT_GRANDFOTHER => 'great-grandfother',
    :BROTHER => 'brother',
    :SISTER => 'sister',
    :OTHER => 'other'    
    }

    scope :is_parent, where(:member_type => MEMBER_TYPE[:PARENT])
end
