class Relation < ActiveRecord::Base
  belongs_to :user, :autosave => true, :validate => true
  belongs_to :family

  validates :token, :uniqueness => true, :presence => true

  accepts_nested_attributes_for :user, :allow_destroy => true#, :reject_if => proc { |attributes| attributes['email'].blank?}

  MEMBER_TYPE = {
    :PARENT => 'parent',
    :MOTHER => 'mother',
    :FATHER => 'father',
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
  
  MEMBER_TYPE_NAME = {
    MEMBER_TYPE[:PARENT] => 'Parent',
    MEMBER_TYPE[:MOTHER] => 'Mother',
    MEMBER_TYPE[:FATHER] => 'Father',
    MEMBER_TYPE[:GRANDMOTHER] => 'Grandmother',
    MEMBER_TYPE[:GRANDFATHER] => 'Grandfather',
    MEMBER_TYPE[:AUNT] => 'Aunt',
    MEMBER_TYPE[:UNCLE] => 'Uncle',
    MEMBER_TYPE[:GODMOTHER] => 'Godmother',
    MEMBER_TYPE[:GODFATHER] => 'Godfather',
    MEMBER_TYPE[:FRIEND] => 'Friend',
    MEMBER_TYPE[:COUSIN] => 'Cousin',
    MEMBER_TYPE[:GREAT_GRANDMOTHER] => 'Great-grandmother',
    MEMBER_TYPE[:GREAT_GRANDFOTHER] => 'Great-grandfother',
    MEMBER_TYPE[:BROTHER] => 'Brother',
    MEMBER_TYPE[:SISTER] => 'Sister',
    MEMBER_TYPE[:OTHER] => 'Other'    
  }

  PARENTS = {
    "Mother" => MEMBER_TYPE[:MOTHER],
    "Father" => MEMBER_TYPE[:FATHER]
  }

  scope :is_parent, where(['member_type in (?)', [MEMBER_TYPE[:PARENT],MEMBER_TYPE[:MOTHER],MEMBER_TYPE[:FATHER]]])
  scope :is_not_parent, where(['member_type not in (?)', [MEMBER_TYPE[:PARENT],MEMBER_TYPE[:MOTHER],MEMBER_TYPE[:FATHER]]])
  scope :accepted, where(:accepted => true)
  scope :not_accepted, where(:accepted => false)
  
  def get_member_type_name
    MEMBER_TYPE_NAME[self.member_type]
  end
end
