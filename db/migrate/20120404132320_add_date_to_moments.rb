class AddDateToMoments < ActiveRecord::Migration
  def change

    add_column :moments, :date, :date
    
  end
end
