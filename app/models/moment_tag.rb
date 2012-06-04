class MomentTag < ActiveRecord::Base
  
  has_many :children_tags, :class_name => "MomentTag"
  belongs_to :parent_tag, :class_name => "MomentTag", :foreign_key => "moment_tag_id"

  has_many :relation_moments, :class_name => "MomentTagsMoments"
  has_many :moments, :through => :relation_moments
  has_and_belongs_to_many :milestones


  scope :names, select(:name)

  scope :main_level, where(:moment_tag_id => nil).order(:id)
  scope :not_main_level, where(["moment_tags.moment_tag_id IS NOT NULL"]).order(:id)
  scope :level_0, where(:level => 0)
  scope :level_1, where(:level => 1)
  scope :level_2, where(:level => 2)
  scope :level_3, where(:level => 3)
  scope :level_4, where(:level => 4)
  scope :level_5, where(:level => 5)
  scope :level_6, where(:level => 6)
  scope :level_7, where(:level => 7)
end
