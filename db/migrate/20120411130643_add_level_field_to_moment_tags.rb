class AddLevelFieldToMomentTags < ActiveRecord::Migration
  def change

    add_column :moment_tags, :level, :integer

  end
end
