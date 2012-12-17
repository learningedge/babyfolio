class SeenBehaviour < ActiveRecord::Base
  belongs_to :child
  belongs_to :behaviour
  belongs_to :user
end
