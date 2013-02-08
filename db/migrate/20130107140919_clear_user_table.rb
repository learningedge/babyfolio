class ClearUserTable < ActiveRecord::Migration
  def up
    remove_column :users, :newsletter
    remove_column :users, :timeline_visited
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_updated_at
    remove_column :users, :avatar_content_type
    
  end

  def down
    add_column :users, :newsletter, :boolean
    add_column :users, :timeline_visited, :boolean
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_updated_at, :datetime
    add_column :users, :avatar_content_type, :string
  end
end
