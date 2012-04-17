class MomentTag < ActiveRecord::Base
  
  has_many :children_tags, :class_name => "MomentTag"  
  belongs_to :parent_tag, :class_name => "MomentTag", :foreign_key => "moment_tag_id"
  has_and_belongs_to_many :moments

 
end