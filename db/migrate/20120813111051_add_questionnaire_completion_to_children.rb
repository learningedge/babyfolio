class AddQuestionnaireCompletionToChildren < ActiveRecord::Migration
  def change
    add_column :children, :basic, :integer
    add_column :children, :normal, :integer
    add_column :children, :advanced, :integer
  end
end
