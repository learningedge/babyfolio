class CreateMilestonesMomentTags < ActiveRecord::Migration
  def change
    create_table :milestones_moment_tags do |t|
      t.integer :milestone_id
      t.integer :moment_tag_id
    end
  end
end
