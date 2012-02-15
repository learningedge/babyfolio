class User < ActiveRecord::Base

  acts_as_authentic
  disable_perishable_token_maintenance(true)

  
#  validates :first_name, :presence => true
#  validates :last_name, :presence => true
#  validates :password, :presence => true, :confirmation => true
#  validates :password_confirmation, :presence => true
#  validates :email, :uniqueness => { :case_sensitive => false }, :presence => true

end
