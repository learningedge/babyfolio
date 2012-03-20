module ApplicationHelper

  def get_image_tag object, style
    if object.kind_of? User
      unless current_user.profile_media.blank?
        image_tag current_user.profile_media.image(style)
      else
        image_tag "/images/default_images/user_profile_#{style}.png"
      end
    elsif object.kind_of? Child
      unless object.media.blank?
        image_tag object.media.image(style)
      else
        image_tag "/images/default_images/child_profile_#{style}.png"
      end
    end
  end

end
