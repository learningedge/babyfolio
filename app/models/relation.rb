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
    "Godmother" => [ "Godson", "Goddaughter" ],
    "Godfather" => [ "Godson", "Goddaughter" ],
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
    "Godmother",
    "Godfather",
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


  # ===========================================
  # ======= Accept / Reject invitation ========
  # ===========================================
  def self.update_relation token, current_user, accepted
    if token.present?
      relation = Relation.find_by_token(token, :include => [[:child => :family], :user, :inviter])
      relations = Relation.joins([[:child => :family]]).find_all_by_accepted_and_user_id(0, current_user.id, :readonly => false, :conditions => { "children.family_id" => relation.child.family_id })
      
      relations.each do |rel|
        if accepted
          rel.update_attribute(:accepted, 1)          
        else
          rel.update_attribute(:accepted, -1)
        end
      end

      UserMailer.invitation_accepted(relation).deliver if accepted      
    end
  end

  # ===========================================
  # =========== Mark user as Admin ============
  # ===========================================
  
  def self.make_admin relation_id, current_user
    relation = Relation.includes([:child => :family]).find_by_id(relation_id)
      
    if relation && relation.child.family.is_admin?(current_user)
      relations_to_update = relation.child.family.relations.find_all_by_user_id(relation.user_id)

      relations_to_update.each do |rel|
        rel.update_attribute(:is_admin, true)
      end

    end

    return relation.child.family.id
  end

  # ===========================================
  # ======== Remove User Admin Powers =========
  # ===========================================
  def self.remove_admin relation_id, current_user
    relation = Relation.includes([:child => :family]).find_by_id(relation_id)

    if relation && relation.child.family.is_admin?(current_user)
      relations_to_update = relation.child.family.relations.find_all_by_user_id(relation.user_id)

      relations_to_update.each do |rel|
        rel.update_attribute(:is_admin, false)
      end
    end

    return relation.child.family.id
  end

  # ===========================================
  # ========== Has Access to change ===========
  # ===========================================
  def self.update_access access, child_id, user_id, current_user
    child = current_user.own_children.includes(:family).find_by_id(child_id)
    
    if child
      if access
        current_relation = child.family.relations.includes(:user).find_by_user_id(user_id)
        user_is_admin = current_relation.is_admin
        display_name = current_relation.display_name || current_relation.user.get_user_name
        member_type = current_relation.member_type
        
        rel = Relation.find_or_initialize_by_child_id_and_user_id(child.id, current_relation.user_id)
        inviter_id = rel.new_record? ? current_user.id : rel.inviter_id
        rel.update_attributes({
                                :accepted => 1,
                                :is_admin => user_is_admin,
                                :display_name => display_name,
                                :member_type => member_type,
                                :token => current_user.perishable_token,
                                :inviter_id => inviter_id,
                                :access => true
        })
        current_user.reset_perishable_token!

      else
        relation = Relation.find_by_child_id_and_user_id(child_id, user_id)
        relation.update_attribute(:access, "false")
      end
    end
  end

  # ===========================================
  # ========= Remove User from family =========
  # ===========================================
  def self.remove_from_family relation_id, current_user
    relation = Relation.includes([:child => :family]).find_by_id(relation_id)

    if relation && relation.child.family.is_admin?(current_user)      
      relations_to_update = relation.child.family.relations.find_all_by_user_id(relation.user_id)

      relations_to_update.each do |rel|
        rel.destroy
      end
    end

    return relation.child.family.id
  end


  def add_object_error(str)
    errors[:base] << str
  end

end
