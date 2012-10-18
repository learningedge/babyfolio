class AddChildIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :child_id, :integer
  end
end
