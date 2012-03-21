class Attachment < ActiveRecord::Base

  belongs_to :media, :autosave => true
  belongs_to :object, :polymorphic => true

#  accepts_nested_attributes_for :media, :allow_destroy => true

end
