class User < ActiveRecord::Base
  attr_accessor :skip_pass_validation
  
  acts_as_authentic 
  disable_perishable_token_maintenance(true)
  
  has_many :relations
  has_many :families, :through => :relations


  accepts_nested_attributes_for :relations, :allow_destroy => true, :reject_if => proc { |attributes| attributes['display_name'].blank?}

  def is_parent?
     !self.relations.is_parent.empty?
  end

  def main_family
    
    unless self.families.parent.empty?
        return self.families.parent.first
      else
        return self.families.first
    end unless self.families.empty?

  end
  

  def get_user_name
    if first_name.empty? || last_name.empty?
      return email
    else
      return first_name + " " + last_name
    end    
  end
  
end
