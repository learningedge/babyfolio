class Behaviour < ActiveRecord::Base
  has_many :activities, :foreign_key => :uid, :primary_key => :uid
  has_many :timeline_entries, :as => :item
  has_many :seen_behaviours 

  CATEGORIES = {
    "L" => "Language",
    "N" => "Logic and Number",
    "S" => "Social",
    "V" => "Visual and Spatial",
    "M" => "Physical and Movement",
    "E" => "Emotion",
#    "m" => "Music"
  }

  def self.get_by_age age
    result = []
    age_category = select('behaviours.category, max(age_from) as age_from').group('behaviours.category').where(["age_from <= ?", age ])
    age_category.each do |ac|
      result << Behaviour.find_by_age_from_and_category(ac.age_from, ac.category)
    end
    result    
  end
end
