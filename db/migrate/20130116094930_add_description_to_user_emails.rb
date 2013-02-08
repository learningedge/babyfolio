class AddDescriptionToUserEmails < ActiveRecord::Migration
  def change
    add_column :user_emails, :description, :string
  end
end
