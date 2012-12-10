class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :activity_id
      t.integer :child_id
      t.boolean :value

      t.timestamps
    end
  end
end
