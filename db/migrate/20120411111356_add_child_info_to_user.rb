class AddChildInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :child_info, :text
  end
end
