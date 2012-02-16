class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|

      t.string :first_name, :null => false
      t.string :second_name
      t.string :last_name
      t.datetime :birth_date, :null => false
      t.integer :family_id, :null => false

      t.timestamps
    end
  end
end
