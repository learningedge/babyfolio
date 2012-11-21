class TimelineEntry < ActiveRecord::Base
  has_many :meta_entries, :class_name => "TimelineMeta"
  has_many :comments, :through => :meta_entries, :source => :object, :source_type => "Comment"
  has_many :media, :through => :meta_entries, :source => :object, :source_type => "Media"
  has_one :child

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
