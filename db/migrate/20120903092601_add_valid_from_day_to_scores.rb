class AddValidFromDayToScores < ActiveRecord::Migration
  def change
    add_column :answers, :valid_from_age_day, :integer
  end
end
