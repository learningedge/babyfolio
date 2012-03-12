class Media < ActiveRecord::Base

has_many :attachments
#has_many :moments, :thought => :attachments

  has_attached_file :image, :styles => { :thumbnail => '100x100' }
 
  PROVIDERS = {
    'FACEBOOK' => 'facebook',
    'YOUTUBE' => 'youtube',
    'FLICKR' => 'flickr'
  }


def self.create_youtube_media(collection, provider)
  media = []
  collection.each do |media| {
#         media << Media.create(
  }
end
