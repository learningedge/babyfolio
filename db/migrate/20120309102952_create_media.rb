class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :media_id
      t.string :type 
      t.has_attached_file :image

      t.timestamps
    end
  end
end
