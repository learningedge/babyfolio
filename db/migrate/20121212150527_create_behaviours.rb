class CreateBehaviours < ActiveRecord::Migration
  def change
    create_table :behaviours do |t|
      t.string :uid      
      t.integer :age_from
      t.integer :age_to
      t.string :category
      t.integer :learning_window
      t.string :expressive_interpretive
      t.string :title_present
      t.string :title_past
      t.text :description_short
      t.text :description_long
      t.text :example1
      t.text :example2
      t.text :example3
      t.text :why_important
      t.text :theory
      t.text :references
      t.text :parenting_tip1
      t.text :parenting_tip2
      t.integer :page
      t.text :background_research_theory
            
      t.timestamps
    end
    add_index :behaviours, :uid, :unique => true
  end
end
