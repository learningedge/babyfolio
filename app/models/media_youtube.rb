class MediaYoutube < MediaVideo
  def self.create_media_objects(id_collection, current_user)
    if id_collection.kind_of? Array
      media = []
      id_collection.each do |x|
        media << MediaYoutube.find_or_create_by_media_id_and_user_id(x, current_user.id)
      end
      media
    else
      media = MediaYoutube.find_or_create_by_media_id_and_user_id(id_collection, current_user.id)
    end
  end
end


