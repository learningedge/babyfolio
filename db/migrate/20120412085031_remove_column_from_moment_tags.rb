class RemoveColumnFromMomentTags < ActiveRecord::Migration
  def up
    remove_column :moment_tags, :statement
    remove_column :moment_tags, :category_tag_id
    remove_column :moment_tags, :child_question
  end

  def down
    add_column :moment_tags, :statement, :string
    add_column :moment_tags, :category_tag_id, :integer
    add_column :moment_tags, :child_question, :string
  end
end
