class RenameTypeColumnToTitleForUserEmails < ActiveRecord::Migration
  def up
    rename_column :user_emails, :type, :title
  end

  def down
    rename_column :user_emails, :title, :type
  end
end
