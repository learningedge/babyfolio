class AddChildIdToRelations < ActiveRecord::Migration
  def change
    add_column :relations, :child_id, :integer
  end
end
