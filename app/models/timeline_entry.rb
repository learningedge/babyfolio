class TimelineEntry < ActiveRecord::Base
  has_many :meta_entries, :class_name => "TimelineMeta"
  has_many :comments, :through => :meta_entries, :source => :object, :source_type => "Comment"
  has_many :media, :through => :meta_entries, :source => :object, :source_type => "Media"
  has_one :child
  belongs_to :user

  def self.build_entry type, did_what, child, author, desc = nil, category = nil, media = nil, who_id = nil
    te = TimelineEntry.new({ :entry_type => type, :child_id => child.id, :user_id => author.id, :description => desc, :category => category})

    med = Media.find_by_id(media)
    te.media << med if med
    who = User.find_by_id(who_id).get_user_name if who_id

    case te.entry_type
      when "play"
        title = "#{child.first_name} and #{who} #{did_what}"
      when "watch"
        title = "#{child.first_name} #{did_what} for #{who}"
      when "reflect"
        title = "#{who} has a question about #{child.first_name}"
      when "likes"
        title = "#{child.first_name} likes #{did_what}"
      when "dislikes"
        title = "#{child.first_name} dislikes #{did_what}"
      else
    end

    te.title = title
    return te
  end

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
