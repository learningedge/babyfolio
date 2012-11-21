class AddCategoryToTimelineEntries < ActiveRecord::Migration
  def change
    add_column :timeline_entries, :category, :string
  end
end
