class MediaFlickr < MediaImage

  def self.create_media_objects(url_collection, id_collection, current_user_id)

    if url_collection.kind_of? Array 
      media = []
      url_collection.each_with_index do |url, idx|
        media << MediaFlickr.find_or_create_by_image_remote_url_and_media_id_and_user_id(url, id_collection[idx], current_user_id)
      end
      media
    else
      media = MediaFlickr.find_or_create_by_image_remote_url_and_media_id_and_user_id(url_collection, id_collection, current_user_id)
    end

  end

end

