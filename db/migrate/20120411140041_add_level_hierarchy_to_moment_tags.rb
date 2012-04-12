class AddLevelHierarchyToMomentTags < ActiveRecord::Migration
  def change

    add_column :moment_tags, :level_hierarchy, :string

  end
end
