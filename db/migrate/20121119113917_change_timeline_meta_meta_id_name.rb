class ChangeTimelineMetaMetaIdName < ActiveRecord::Migration
  def up
      rename_column :timeline_meta, :meta_id, :object_id
      rename_column :timeline_meta, :meta_type, :object_type      
  end

  def down
      rename_column :timeline_meta, :object_id, :meta_id
      rename_column :timeline_meta, :object_type, :meta_type
  end
end
