class ChangeLogs < ActiveRecord::Migration
  def up
    change_column :logs, :description, :text
  end

  def down
    change_column :logs, :description, :string
  end
end
