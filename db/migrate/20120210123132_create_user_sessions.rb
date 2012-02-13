class CreateUserSessions < ActiveRecord::Migration
  def change

    create_table :user_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.date :update_at
      t.timestamps
    end

    add_index :user_sessions, :session_id
    add_index :user_sessions, :update_at
  end
end
