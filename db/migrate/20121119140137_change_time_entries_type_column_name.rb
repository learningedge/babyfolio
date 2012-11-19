class ChangeTimeEntriesTypeColumnName < ActiveRecord::Migration
  def up
    rename_column :timeline_entries, :type, :entry_type
  end

  def down
    rename_column :timeline_entries,  :entry_type, :type
  end
end
