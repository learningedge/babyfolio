class AddMidToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :mid, :integer
  end
end
