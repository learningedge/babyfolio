class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :media_id     
      t.integer :moment_id
      t.integer :child_id

      t.timestamps
    end
  end
end
