class AddCountToUserEmails < ActiveRecord::Migration
  def change
    add_column :user_emails, :count, :integer, :default => 0
  end
end
