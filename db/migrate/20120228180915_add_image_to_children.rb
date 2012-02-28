class AddImageToChildren < ActiveRecord::Migration
  def change
    change_table :children do |t|
      t.has_attached_file :profile_image
    end
  end
end
