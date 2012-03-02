class AddProfileImageRemoteUrlToChildren < ActiveRecord::Migration
  def change
    change_table :children do |t|
      t.string :profile_image_remote_url
    end
  end
end
