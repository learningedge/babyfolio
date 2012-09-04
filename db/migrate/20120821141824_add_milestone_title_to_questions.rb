class AddMilestoneTitleToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :milestone_title, :string
  end
end
