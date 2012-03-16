class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.string :title

      t.timestamps
    end
  end
end
