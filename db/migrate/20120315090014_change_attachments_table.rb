class ChangeAttachmentsTable < ActiveRecord::Migration

  def up

    remove_column :attachments, :moment_id
    remove_column :attachments, :child_id
    add_column :attachments, :object_id, :integer
    add_column :attachments, :object_type, :string

  end

  def down

    add_column :attachments, :moment_id, :integer
    add_column :attachments, :child_id, :integer
    remove_column :attachments, :object_id
    remove_column :attachments, :object_type

  end

end
