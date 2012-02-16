class User < ActiveRecord::Base

  acts_as_authentic
  disable_perishable_token_maintenance(true)

  has_many :relations
  has_many :families, :through => :relations

  def has_family?
     self.relations.is_parent.empty?
  end

end
