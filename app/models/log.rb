class Log < ActiveRecord::Base
  belongs_to :user

  def self.create_log user_id, description
    Log.create(:user_id => user_id, :description => description.join("<br/>"))
  end
end
