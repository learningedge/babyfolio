class CreateSeenBehaviours < ActiveRecord::Migration
  def change
    create_table :seen_behaviours do |t|
      t.integer :child_id
      t.integer :behaviour_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
