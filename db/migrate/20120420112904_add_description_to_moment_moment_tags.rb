class AddDescriptionToMomentMomentTags < ActiveRecord::Migration
  def change
    add_column :moment_tags_moments, :description, :string
  end
end
