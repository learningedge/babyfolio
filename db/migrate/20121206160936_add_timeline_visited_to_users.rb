class AddTimelineVisitedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timeline_visited, :boolean, :default => false
  end
end
