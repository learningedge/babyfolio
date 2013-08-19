class AddIsTemporaryFieldToChildren < ActiveRecord::Migration
  def change
    add_column :children, :is_temporary, :boolean, :default => false
  end
end
