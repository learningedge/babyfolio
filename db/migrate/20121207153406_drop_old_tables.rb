class DropOldTables < ActiveRecord::Migration
  def up
    drop_table :families
    drop_table :milestones_moment_tags
    drop_table :moments
    drop_table :moment_connections
    drop_table :moment_tags
    drop_table :moment_tags_moments
    drop_table :scores
    drop_table :services
    

  end

  def down
  end
end
