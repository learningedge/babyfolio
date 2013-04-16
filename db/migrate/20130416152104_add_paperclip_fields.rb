class AddPaperclipFields < ActiveRecord::Migration
  def up
    add_column :custom_fields, :custom_image_file_name, :string
    add_column :custom_fields, :custom_image_file_size, :integer
    add_column :custom_fields, :custom_image_content_type, :string
    add_column :custom_fields, :custom_image_updated_at, :datetime
  end

  def down
    remove_column :custom_fields, :custom_image_file_name
    remove_column :custom_fields, :custom_image_file_size
    remove_column :custom_fields, :custom_image_content_type
    remove_column :custom_fields, :custom_image_updated_at
  end
end
