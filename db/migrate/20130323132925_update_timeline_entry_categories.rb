class UpdateTimelineEntryCategories < ActiveRecord::Migration
  def up
      categories = {
        "l" => "L",
        "ln" => "N",
        "s" => "S",
        "v" => "V",
        "mv" => "M",
        "e" =>  "E",
        "m" => "MU"
      }

      TimelineEntry.all.each do |te|
        te.update_attribute(:category, categories[te.category] )
      end
  end

  def down
  end
end
