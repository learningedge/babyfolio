class ChangeMilestonesMidType < ActiveRecord::Migration
  def up
    change_column :milestones, :mid, :string
  end

  def down
    change_column :milestones, :mid, :integer
  end
end
