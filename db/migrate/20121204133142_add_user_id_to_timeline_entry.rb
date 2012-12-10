class AddUserIdToTimelineEntry < ActiveRecord::Migration
  def change
    add_column :timeline_entries, :user_id, :integer
  end
end
