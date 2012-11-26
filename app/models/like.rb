class Like < ActiveRecord::Base
  belongs_to :child
  belongs_to :activity, :class_name => 'Milestone'
end
