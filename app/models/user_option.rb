class UserOption < ActiveRecord::Base
  belongs_to :user

  def get_next_newsletter_categories current_category
    categories = []
    categories << 'l' if self.language
    categories << 'ln' if self.language
    categories << 's' if self.social
    categories << 'v' if self.visual
    categories << 'mv' if self.movement
    categories << 'e' if self.emotional
    earlier, later = categories.partition{|i| categories.index(i) <= categories.index(current_category) }

    result = later + earlier
  end
end
