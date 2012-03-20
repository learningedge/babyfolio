class DeleteImagesFieldsFromChildren < ActiveRecord::Migration
  def up
    remove_column :children, :profile_image_file_size
    remove_column :children, :profile_image_file_name
    remove_column :children, :profile_image_updated_at
    remove_column :children, :profile_image_content_type
    remove_column :children, :profile_image_remote_url
  end

  def down
    add_column :children, :profile_image_file_size, :integer
    add_column :children, :prorile_image_file_name, :string
    add_column :children, :profile_image_update_at, :date
    add_column :children, :profile_image_content_type, :string
    add_column :children, :profile_image_remote_url, :string
  end
end
