class UserOption < ActiveRecord::Base
  belongs_to :user

  def get_next_newsletter_categories current_category
    categories = []
    categories << 'L' if self.language
    categories << 'N' if self.logic
    categories << 'S' if self.social
    categories << 'V' if self.visual
    categories << 'M' if self.movement
    categories << 'E' if self.emotional    
    earlier, later = categories.partition{|i| categories.index(i) <= categories.index(current_category) }

    result = later + earlier
  end
end
