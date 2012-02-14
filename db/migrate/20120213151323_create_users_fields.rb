class CreateUsersFields < ActiveRecord::Migration
  def change

    add_column :users, :current_login_at, :date, :null => true

  end
end
