class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|

      t.timestamps
      t.integer :page_id
      t.string :slug
      t.string :label
      t.text :content
      t.integer :menu_order
      t.string :field_type

    end
  end
end
