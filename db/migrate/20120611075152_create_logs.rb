class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|

      t.string :description
      t.integer :user_id
      
      t.timestamps
    end
  end
end
