class AddIsTemporaryToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_temporary, :boolean, :default => false
    remove_column :users, :child_info
  end
end
