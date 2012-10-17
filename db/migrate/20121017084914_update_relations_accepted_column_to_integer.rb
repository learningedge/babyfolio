class UpdateRelationsAcceptedColumnToInteger < ActiveRecord::Migration
  def up
    change_column :relations, :accepted, :integer
  end

  def down
    change_column :relations, :accepted, :boolean
  end
end
