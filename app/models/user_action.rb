class UserAction < ActiveRecord::Base
  belongs_to :user
  has_one :child
end
