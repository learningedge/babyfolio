class UserAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :child

  def self.no_older_than date
    where(["user_actions.created_at >= ?", date])
  end
end
