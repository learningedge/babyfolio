class AddChildIdToUserEmails < ActiveRecord::Migration
  def change
    add_column :user_emails, :child_id, :integer
  end
end
