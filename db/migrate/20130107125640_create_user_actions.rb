class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|

      t.integer :user_id
      t.integer :child_id
      t.string :title

      t.timestamps
    end

    add_index :user_actions, :title
  end
end
