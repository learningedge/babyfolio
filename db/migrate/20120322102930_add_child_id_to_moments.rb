class AddChildIdToMoments < ActiveRecord::Migration
  def change
    add_column :moments, :child_id, :integer

  end
end
