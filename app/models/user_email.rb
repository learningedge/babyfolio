class UserEmail < ActiveRecord::Base
  belongs_to :user
  belongs_to :child

  before_save :update_count
  
  private
  def update_count
    self.count += 1
  end
end
