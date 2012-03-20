class Attachment < ActiveRecord::Base

  belongs_to :media
  belongs_to :object, :polymorphic => true

end
