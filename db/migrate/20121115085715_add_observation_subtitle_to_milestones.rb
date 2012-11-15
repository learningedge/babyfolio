class AddObservationSubtitleToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :observation_subtitle, :text
  end
end
