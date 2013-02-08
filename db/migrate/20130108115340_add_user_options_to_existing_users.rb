class AddUserOptionsToExistingUsers < ActiveRecord::Migration
  def change
    User.all.each do |u|
      u.user_option = UserOption.new
      u.save
    end
  end
end
