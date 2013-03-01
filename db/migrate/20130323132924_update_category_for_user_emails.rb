class UpdateCategoryForUserEmails < ActiveRecord::Migration
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

      UserEmail.all.each do |ue|
        ue.update_attribute(:description, categories[ue.description] )
      end
  end

  def down
  end
end
