class CreateTimelineEntries < ActiveRecord::Migration
  def change
    create_table :timeline_entries do |t|
      t.string :type
      t.string :title
      t.text :description
      t.integer :child_id

      t.timestamps
    end
  end
end
