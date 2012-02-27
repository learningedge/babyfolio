class User < ActiveRecord::Base    
  acts_as_authentic do |t|
    t.ignore_blank_passwords = false;
  end
  disable_perishable_token_maintenance(true)
  
  has_many :relations
  has_many :families, :through => :relations

  #  accepts_nested_attributes_for :relations, :allow_destroy => true, :reject_if => proc { |attributes| attributes['display_name'].blank?}

  def is_parent?
    !self.relations.is_parent.empty?
  end

  def main_family    
    unless self.families.parenting_families.empty?
      return self.families.parenting_families.first
    else
      return self.families.first
    end
    unless self.families.empty?
      return self.families.first
    end
  end
  
  def get_user_name
    if first_name.nil? || last_name.nil?
      return email.split('@').first.capitalize unless email.nil?
    else 
      return first_name.capitalize + " " + last_name.capitalize
    end
  end
  
end
