class ChangeFamilyIdToNullableForChildren < ActiveRecord::Migration
  def up
    change_column :children, :family_id, :integer, :null => true
  end

  def down
    change_column :children, :family_id, :integer, :null => false
  end
end
