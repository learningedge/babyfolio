class CreateScores < ActiveRecord::Migration
  def change
    remove_column :answers, :child_id    
    add_column :answers, :score_id, :integer
    rename_column :answers, :answer, :value
    create_table :scores do |t|
      t.integer :child_id
      t.integer :age
      t.string :category
      t.decimal :value, :precision => 3, :scale => 2

      t.timestamps
    end
  end
end
