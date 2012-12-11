class CreateMomentTags < ActiveRecord::Migration
  def change
    create_table :moment_tags do |t|

      t.string  :name
      t.string  :require_level_afinity
      t.string  :value_type
      t.string  :value_range
      t.string  :parent_question
      t.string  :child_question
      t.string  :statement
      t.integer :category_tag_id

      t.timestamps
    end
  end
end
