require 'open-uri'

class MediaImage < Media


  def self.create_media_object(image, current_user_id)
    media = MediaImage.create(:image => image, :user_id => current_user_id)
  end
end



