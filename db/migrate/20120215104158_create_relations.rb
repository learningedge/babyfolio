class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :user_id
      t.integer :family_id
      t.string :member_type
      t.string :display_name
    end
  end
end
