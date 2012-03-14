class AddImageRemoteUrlToMedia < ActiveRecord::Migration
  def change
    add_column :media, :image_remote_url, :string
  end
end
