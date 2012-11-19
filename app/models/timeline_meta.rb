class TimelineMeta < ActiveRecord::Base
  belongs_to :timeline_entry
  belongs_to :object, :polymorphic => true

end
