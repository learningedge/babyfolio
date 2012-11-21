class Comment < ActiveRecord::Base  
  has_one :timeline_meta, :as => :object
  belongs_to :author, :class_name => "User", :foreign_key => :user_id

  def published
    if(Time.now.to_date == self.created_at.to_date)
      "Today"
    elsif Time.now.to_date - 1.days == self.created_at.to_date
      "Yesterday"
    else
      self.created_at.strftime("%-m/%-d/%y")
    end
  end
end
