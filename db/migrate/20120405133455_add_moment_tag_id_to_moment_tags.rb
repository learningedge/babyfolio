class AddMomentTagIdToMomentTags < ActiveRecord::Migration
  def change

    add_column :moment_tags, :moment_tag_id, :integer
    
  end
end
