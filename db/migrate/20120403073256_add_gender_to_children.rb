class AddGenderToChildren < ActiveRecord::Migration
  def change
    add_column :children, :gender, :string, :default => 'male'
  end
end
