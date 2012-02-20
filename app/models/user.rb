class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.ignore_blank_passwords = true
  end
  disable_perishable_token_maintenance(true)

  has_many :relations
  has_many :families, :through => :relations


  accepts_nested_attributes_for :relations, :allow_destroy => true, :reject_if => proc { |attributes| attributes['display_name'].blank?}

  def is_parent?
     !self.relations.is_parent.empty?
  end

  def main_family
    unless self.families.empty?
      unless self.families.parent.empty?

        return self.families.parent.first

      else

        return self.families.first
        
      end
    end
  end
  

end
