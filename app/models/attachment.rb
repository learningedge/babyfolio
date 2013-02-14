class Attachment < ActiveRecord::Base

  belongs_to :media, :autosave => true, :dependent => :destroy
  belongs_to :object, :polymorphic => true


end
