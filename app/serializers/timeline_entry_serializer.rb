class TimelineEntrySerializer < ActiveModel::Serializer
  attributes :published, :category, :title, :description, :photo_url, :user_photo

  has_many :comments

  def title
    object.title.gsub(%r{</?[^>]+?>}, '')
  end

  def user_photo
    object.user.get_image_src(:profile_small, ' ') if object.user.present? && object.user.profile_media
  end

  def photo_url
    if object.media.first
      object.media.first.image.url(:attachment_large)
    end
  end

end
