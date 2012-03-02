class AddFlickrIdToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :flickr_id
    end
  end
end
