class UserSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :email, :id, :user_photo_url

  has_many :children

  def user_photo_url
    object.get_image_src(:profile_small, ' ') 
  end

end


