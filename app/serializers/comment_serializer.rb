class CommentSerializer < ActiveModel::Serializer
  attributes :text, :author_name, :author_photo, :published

  def author_name
    object.author.get_user_name
  end

  def author_photo
    object.author.profile_media.image.url(:profile_tiny) if object.author.profile_media
  end

end
