class Attachment < ActiveRecord::Base

  belongs_to :media, :autosave => true
  belongs_to :object, :polymorphic => true


end
