class Activity < ActiveRecord::Base
  belongs_to :behaviour, :primary_key => :uid, :foreign_key => :uid
  has_many :timeline_entries, :as => :item
  has_many :likes
end
