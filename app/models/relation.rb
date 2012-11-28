class Relation < ActiveRecord::Base
  belongs_to :user, :autosave => true, :validate => true
  belongs_to :child, :autosave => true, :validate => true
  belongs_to :inviter, :class_name => 'User'

  validates :token, :uniqueness => true, :presence => true

  accepts_nested_attributes_for :user, :allow_destroy => true

  TYPES = {
    "Father" => [ "Son", "Daughter" ],
    "Mother" => [ "Son", "Daughter" ],   
    "Aunt" => [ "Nephew", "Niece" ],
    "Uncle" => [ "Nephew", "Niece" ],
    "Grandmother" => [ "Grandson", "Granddaughter" ],
    "Grandfather" => [ "Grandson", "Granddaughter" ],
    "Brother" => [ "Brother", "Sister" ],
    "Sister" => [ "Brother", "Sister" ],
    "Step-Mother" => [ "Step-son", "Step-daughter" ],
    "Step-Father" => [ "Step-son", "Step-daughter" ],
    "Nanny" => ["friend", "friend"],
    "Babysitter" => ["friend", "friend"],
    "Friend" => ["friend", "friend"]
  }

  TYPE_KEYS = [
    "Father",
    "Mother",
    "Aunt",
    "Uncle",
    "Grandmother",
    "Grandfather",
    "Brother",
    "Sister",
    "Step-Mother",
    "Step-Father",
    "Nanny",
    "Babysitter",
    "Friend",
  ]

  def get_opposite_relation_type
    if self.child.gender == "male"
      Relation::TYPES[self.member_type][0]
    else
      Relation::TYPES[self.member_type][1]
    end
  end


#  MEMBER_TYPE = {
#    :PARENT => 'parent',
#    :MOTHER => 'mother',
#    :FATHER => 'father',
#    :GRANDMOTHER => 'grandmother',
#    :GRANDFATHER => 'grandfather',
#    :AUNT => 'aunt',
#    :UNCLE => 'uncle',
#    :GODMOTHER => 'godmother',
#    :GODFATHER => 'godfather',
#    :FRIEND => 'friend',
#    :COUSIN => 'cousin',
#    :GREAT_GRANDMOTHER => 'great-grandmother',
#    :GREAT_GRANDFOTHER => 'great-grandfother',
#    :BROTHER => 'brother',
#    :SISTER => 'sister',
#    :OTHER => 'other'
#  }
#
#  MEMBER_TYPE_NAME = {
#    MEMBER_TYPE[:PARENT] => 'Parent',
#    MEMBER_TYPE[:MOTHER] => 'Mother',
#    MEMBER_TYPE[:FATHER] => 'Father',
#    MEMBER_TYPE[:GRANDMOTHER] => 'Grandmother',
#    MEMBER_TYPE[:GRANDFATHER] => 'Grandfather',
#    MEMBER_TYPE[:AUNT] => 'Aunt',
#    MEMBER_TYPE[:UNCLE] => 'Uncle',
#    MEMBER_TYPE[:GODMOTHER] => 'Godmother',
#    MEMBER_TYPE[:GODFATHER] => 'Godfather',
#    MEMBER_TYPE[:FRIEND] => 'Friend',
#    MEMBER_TYPE[:COUSIN] => 'Cousin',
#    MEMBER_TYPE[:GREAT_GRANDMOTHER] => 'Great-grandmother',
#    MEMBER_TYPE[:GREAT_GRANDFOTHER] => 'Great-grandfother',
#    MEMBER_TYPE[:BROTHER] => 'Brother',
#    MEMBER_TYPE[:SISTER] => 'Sister',
#    MEMBER_TYPE[:OTHER] => 'Other'
#  }

#  scope :is_parent, where(['member_type in (?)', [MEMBER_TYPE[:PARENT],MEMBER_TYPE[:MOTHER],MEMBER_TYPE[:FATHER]]])
#  scope :is_not_parent, where(['member_type not in (?)', [MEMBER_TYPE[:PARENT],MEMBER_TYPE[:MOTHER],MEMBER_TYPE[:FATHER]]])
#  scope :accepted, where(:accepted => true)
#  scope :not_accepted, where(:accepted => false)
  
#  def get_member_type_name
#    MEMBER_TYPE_NAME[self.member_type]
#  end

  def add_object_error(str)
    errors[:base] << str
  end

end
