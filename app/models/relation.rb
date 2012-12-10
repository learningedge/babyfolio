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

  def add_object_error(str)
    errors[:base] << str
  end

end
