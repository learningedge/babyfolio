class User < ActiveRecord::Base

  acts_as_authentic
  disable_perishable_token_maintenance(true)

  has_many :relations
  has_many :families, :through => :relations

  def is_parent?
     self.relations.is_parent.empty?
  end

end
