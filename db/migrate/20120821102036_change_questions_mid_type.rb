class ChangeQuestionsMidType < ActiveRecord::Migration
  def up
    change_column :questions, :mid, :string
  end

  def down
    change_column :questions, :mid, :integer
  end
end
