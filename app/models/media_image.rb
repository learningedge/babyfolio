class MediaImage < Media

  def self.create_image_objects(url_collection, id_collection)
    media = []
    url_collection.each do |url, idx|
        media << MediaImage.create(:image => url, :media_id => id_collection[idx])
    end
    media
  end

end


class MediaFacebook < MediaImage
end



class MediaFlickr < MediaImage
end

