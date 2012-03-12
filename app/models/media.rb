class Media < ActiveRecord::Base

  has_many :attachments
  #has_many :moments, :thought => :attachments
  attr_accessor :image_remote_url

  has_attached_file :image, :styles => { :thumbnail => '100x100' }


  private

  def download_remote_image
    self.image = do_download_remote_image unless self.image_remote_url.blank?
  end

  def do_download_remote_image
    io = open(URI.parse(self.image_remote_url))
    def 
      io.original_filename; base_uri.path.split('/').last;
    end
    io.original_filename.blank? ? nil : io
  rescue
  end

end
