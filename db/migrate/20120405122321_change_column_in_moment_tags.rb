class ChangeColumnInMomentTags < ActiveRecord::Migration
  def up
    rename_column :moment_tags, :require_level_afinity, :require_level_affinity
  end

  def down
    rename_column :moment_tags, :require_level_affinity, :require_level_afinity
  end
end
