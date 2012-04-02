class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :category
      t.text :text
      t.integer :age

      t.timestamps
    end
  end
end
