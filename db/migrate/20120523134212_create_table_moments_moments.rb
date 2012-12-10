class CreateTableMomentsMoments < ActiveRecord::Migration
  def change
    create_table :moment_connections do |t|
      
      t.integer :connected_parent_id
      t.integer :connected_child_id
      
    end
  end
  
end
