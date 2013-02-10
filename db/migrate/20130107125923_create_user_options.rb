class CreateUserOptions < ActiveRecord::Migration
  def change
    create_table :user_options do |t|

      t.integer :user_id
      t.boolean :subscribed, :default => true
      t.string :newsletter_frequency, :default => "weekly"
      t.boolean :language, :default => true
      t.boolean :logic, :default => true
      t.boolean :social, :default => true
      t.boolean :visual, :default => true
      t.boolean :movement, :default => true
      t.boolean :emotional, :default => true
    end
  end
end
