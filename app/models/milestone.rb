class Milestone < ActiveRecord::Base
  include ApplicationHelper

  has_and_belongs_to_many :moment_tags
  has_many :questions, :class_name =>"Question", :foreign_key => 'mid', :primary_key => 'mid'

  def activity_1_title_text child
    [child.replace_forms(activity_1_title), child.replace_forms(activity_1_subtitle), child.replace_forms(smart_truncate(activity_1_response)), child.replace_forms(smart_truncate(activity_1_modification))].find{|i| i.present?}
  end

  def activity_2_title_text child
    [child.replace_forms(activity_2_title), child.replace_forms(activity_2_subtitle), child.replace_forms(smart_truncate(activity_2_response)), child.replace_forms(smart_truncate(activity_2_modification))].find{|i| i.present?}
  end

end
