require 'open-uri'

class MediaImage < Media


  def self.create_media_object(image, current_user_id)
    media = MediaImage.create(:image => image, :user_id => current_user_id)
  end

#  before_save :download_remote_image

#  protected
#
#   def download_remote_image
#     self.image = do_download_remote_image unless self.image_remote_url.blank?
#   end
#
#   def do_download_remote_image
#     io = open(URI.parse(self.image_remote_url))
#     def
#       io.original_filename; base_uri.path.split('/').last;
#     end
#     io.original_filename.blank? ? nil : io
#   rescue
#   end
#

end



