class MomentTagsMoments< ActiveRecord::Base

  belongs_to :moment
  belongs_to :moment_tag


  def is_last_in_hierarchy
    moment_tags = self.moment.moment_tags
    true if (self.moment_tag.children_tags & moment_tags).blank?
  end
end