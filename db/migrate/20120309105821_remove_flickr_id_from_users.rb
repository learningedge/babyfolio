class RemoveFlickrIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :flickr_id
  end

  def down
    add_column :users, :flickr_id, :string
  end
end
