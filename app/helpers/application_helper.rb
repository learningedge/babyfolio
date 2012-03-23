module ApplicationHelper

  def get_image_tag object, style
    if object.kind_of? User
      unless object.profile_media.blank?
        image_tag object.profile_media.image(style)
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

  def get_moment_thumb object, style
    if object.kind_of? MediaImage
      image_tag object.image(style)
    elsif object.kind_of? MediaVimeo
      "Vimeo Video"
    elsif object.kind_of? MediaYoutube
      begin
      video = youtube_client.video_by(object.media_id)
      image_tag video.thumbnails[0].url
      rescue
        return "<span class='error-text'>The video doesn't seem to exist</span>".html_safe
      end

    end
  end

  def youtube_client
    return @client if defined?(@client)
    @client = YouTubeIt::Client.new(:dev_key => Yetting.youtube["dev_key"])
  end

end
