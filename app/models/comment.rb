class Comment < ActiveRecord::Base  
  has_one :timeline_meta, :as => :object  
end
