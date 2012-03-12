class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :media_id
      t.string :provider
      t.string :type 
      t.has_attached_field :image

      t.timestamps
    end
  end
end
