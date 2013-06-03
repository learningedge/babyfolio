class AddIsWelcomeProgramEnabled < ActiveRecord::Migration
  def up
    add_column :user_options, :is_welcome_program_enabled, :boolean, :default => true
  end

  def down
    remove_column :user_options, :is_welcome_program_enabled
  end
end
