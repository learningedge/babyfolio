class Media < ActiveRecord::Base

  belongs_to :user
  has_one :timeline_meta, :as => :object
  has_many :attachments
  
  has_attached_file :image, :styles => { 

    :profile_tiny => "32x32#",
    :profile_small => "50x50#",
    :profile_medium => "161x155#",
    :profile_large => "320x288#",
    :attachment_large => "310x310"
  }

  def media_type
    if self.kind_of? MediaImage
      "Photo"
    elsif self.kind_of? MediaVideo
      "Video"
    end
  end

#  def youtube_object
#    begin
#      if self.user.youtube_user
#        self.user.youtube_user.my_video(self.media_id)
#      else
#        client = YouTubeIt::Client.new(:dev_key => Yetting.youtube["dev_key"])
#        client.video_by(self.media_id)
#      end
#    rescue
#      return nil
#    end
#  end
#
#  def vimeo_object
#    begin
#      if self.user.has_vimeo_account?
#        client = self.user.vimeo_client
#        video = client.get_info(self.media_id)
#        video["video"][0]
#      else
#        video = Vimeo::Simple::Video.info(self.media_id)
#        video[0]
#      end
#    rescue
#      return nil
#    end
#  end
end
