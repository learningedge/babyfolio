class AddInviterIdToRelations < ActiveRecord::Migration
  def change
    add_column :relations, :inviter_id, :integer
  end
end
