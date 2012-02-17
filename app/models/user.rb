class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.ignore_blank_passwords = true
  end
  disable_perishable_token_maintenance(true)

  has_many :relations
  has_many :families, :through => :relations

  accepts_nested_attributes_for :relations, :allow_destroy => true, :reject_if => proc { |attributes| attributes['display_name'].blank?}

  def has_family?
    self.relations.is_parent.empty?
  end

end
