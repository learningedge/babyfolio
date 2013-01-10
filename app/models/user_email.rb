class UserEmail < ActiveRecord::Base
  belongs_to :user

  before_save :update_count

  private
  def update_count
    self.count += 1
  end
end
