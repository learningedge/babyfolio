class CreateTimelineMeta < ActiveRecord::Migration
  def change
    create_table :timeline_meta do |t|
      t.integer :timeline_entry_id
      t.integer :meta_id
      t.string  :meta_type

      t.timestamps
    end
  end
end
