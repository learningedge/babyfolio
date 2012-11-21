class Comment < ActiveRecord::Base  
  has_one :timeline_meta, :as => :object
  belongs_to :author, :class_name => "User", :foreign_key => :user_id

  def published
    if (Time.now.to_datetime - self.created_at.to_datetime).to_i < 1
      "Today"
    elsif (Time.now.to_datetime - self.created_at.to_datetime).to_i == 1
      "Yesterday"
    else
      self.created_at.strftime("%-m/%-d/%y")
    end
  end
end
