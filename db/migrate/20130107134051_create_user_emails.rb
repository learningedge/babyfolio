class CreateUserEmails < ActiveRecord::Migration
  def change
    create_table :user_emails do |t|
      t.integer :user_id     
      t.string :type

      t.timestamps
    end
  end
end
