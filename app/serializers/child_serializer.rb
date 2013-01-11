class ChildSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :gender, :birthday, :id, :baby_photo_url, :relationship

  def birthday
    object.formated_birth_date
  end

  def baby_photo_url
    object.get_image_src(:profile_large, " ")
  end

  def relationship
    object.relation_to_current_user scope
  end

end
