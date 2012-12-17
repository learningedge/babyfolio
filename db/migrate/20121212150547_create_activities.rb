class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :uid
      t.string :activity_uid
      t.integer :age_from
      t.integer :age_to
      t.string :category
      t.string :expressive_interpretive
      t.string :title
      t.string :action
      t.string :actioned
      t.text :description_short
      t.text :description_long
      t.text :variation1
      t.text :variation2
      t.text :variation3
      t.text :learning_benefit
      t.integer :page
      t.text :note
      t.text :real_world_interests           

      t.timestamps
    end
    add_index :activities, :uid
    add_index :activities, :activity_uid, :unique => true
  end
end
