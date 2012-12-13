class AddIsAutoToTimelineEntries < ActiveRecord::Migration
  def change
    add_column :timeline_entries, :is_auto, :boolean, :default => false
  end
end
