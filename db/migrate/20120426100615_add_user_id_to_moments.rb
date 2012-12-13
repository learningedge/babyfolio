class AddUserIdToMoments < ActiveRecord::Migration
  def change
    add_column :moments, :user_id, :int
  end
end
