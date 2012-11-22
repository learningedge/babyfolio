class ChangeTableLogsOptions < ActiveRecord::Migration
  def up
    drop_table :logs
    create_table :logs do |t|

      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end

  def down
    drop_table :logs
    create_table :logs do |t|

      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
