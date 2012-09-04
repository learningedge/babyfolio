module ApplicationHelper

  def set_blank_input_value text
    if text == Family::DEFAULTS[:family_name] or text == Family::DEFAULTS[:zipcode] or text == Child::DEFAULTS[:first_name]
      ""
    else
      text
    end
  end

  def get_image_tag object, style
    image_tag get_image_url(object, style)
  end


  def get_image_url object, style
    if object.kind_of? User
      unless object.profile_media.blank?
        object.profile_media.image(style)
      else
        "/images/default_images/user_profile_#{style}.png"
      end
    elsif object.kind_of? Child
      if !object.media.blank? and !object.media.image_file_size.blank?
        object.media.image(style)
      else
        "/images/default_images/child_profile_#{style}.png"
      end
    end
  end

  def get_moment_thumb object, style
    
    if object.kind_of? MediaImage

      image_tag object.image(style)
      
    elsif object.kind_of? MediaVimeo
      
       video = object.vimeo_object
       if video
         image_tag (video["thumbnail_medium"].nil? ? video["thumbnails"]["thumbnail"][1]["_content"] : video["thumbnail_medium"])
       else
         "<span class='error-text'>The video was not found</span>".html_safe
       end

    elsif object.kind_of? MediaYoutube
      
      video = object.youtube_object
      if video
        image_tag video.thumbnails[0].url
      else
        "<span class='error-text'>The video was not found</span>".html_safe
      end

    else
      image_tag "/images/default_images/child_profile_#{style}.png"
    end
    
  end

  def smart_truncate(s, opts = {})
    opts = {:words => 12 }.merge(opts)    
    a = s.split(/\s/)
    n = opts[:words] - 1
    a[0..n].join(' ') + (a.size > n ? '...' : '')
  end

  

#  def youtube_client
#    return @client if defined?(@client)
#    @client = YouTubeIt::Client.new(:dev_key => Yetting.youtube["dev_key"])
#  end

#  def vimeo_video_client service
#    return @vimeo_client if defined?(@vimeo_client)
#    @vimeo_client = Vimeo::Advanced::Video.new(Yetting.vimeo["key"], Yetting.vimeo["secret"], :token => service.token, :secret => service.secret)
#  end

end
