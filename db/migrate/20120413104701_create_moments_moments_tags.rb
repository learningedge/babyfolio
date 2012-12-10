class CreateMomentsMomentsTags < ActiveRecord::Migration
  def change
    create_table :moment_tags_moments do |t|
      t.integer :moment_id
      t.integer :moment_tag_id
    end
  end
end
