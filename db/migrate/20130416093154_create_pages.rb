class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|

      t.timestamps
      t.string :slug
      t.string :title
      
    end
  end
end
