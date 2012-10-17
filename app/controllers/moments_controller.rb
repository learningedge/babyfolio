class MomentsController < ApplicationController

  before_filter :require_user
  before_filter :require_child
  skip_before_filter :clear_family_registration, :only => [:import_media, :import_videos]  

  def index

  end

  def new
    if current_user.can_edit_child? params[:child_id]

      if params[:milestone_id]
        @milestone = Milestone.find(params[:milestone_id])
      end

      @moment = Moment.new
      @moment.child = Child.find(params[:child_id])
      @moment_tags = MomentTag.find_all_by_level(nil)

    else
      redirect_to errors_permission_path
    end
  end

  def create
    if current_user.can_edit_child?(params[:cid])
      media = []
      media += Media.find(params[:uploaded_images_pids]) unless params[:uploaded_images_pids].blank?
      media += MediaFacebook.create_media_objects(params[:facebook_photos], params[:facebook_pids], current_user.id)  unless  params[:facebook_photos].blank?
      media += MediaFlickr.create_media_objects(params[:flickr_photos], params[:flickr_pids], current_user.id)  unless  params[:flickr_pids].blank?
      media += MediaYoutube.create_media_objects(params[:youtube_videos], current_user.id)  unless  params[:youtube_videos].blank?
      media += MediaVimeo.create_media_objects(params[:vimeo_videos], current_user.id)  unless  params[:vimeo_videos].blank?

      moment = Moment.new(params[:moment])
      moment.child_id = params[:cid]
      moment.user_id = current_user.id
      media.each do |m|
        moment.attachments.build({ :media => m})
      end

      unless params[:moment_tag_ids].blank?

        moment_tags = MomentTag.find(params[:moment_tag_ids])
        moment_tags.each {|moment_tag| moment.moment_tags << moment_tag}
        
      end

      if moment.save
        flash[:notice] = "Moment has been successfuly created."

        log_description = Array.new
        log_description << "MOMENT ##{moment.id} CREATED:"
        log_description << "Child: #{moment.child.first_name}"
        log_description << "Title: #{moment.title}"
        log_description << "Tags: #{(moment.moment_tags.collect {|moment_tag| moment_tag.name}).join(', ')}" unless moment.moment_tags.blank?

        Log.create_log current_user.id, log_description
        
        unless current_user.is_temporary
          unless moment.visibility == Moment::VISIBILITY["Me only"]
            UserMailer.email_new_moment(current_user, moment).deliver
          end
          if params[:operation_type] == "tag_it"
            redirect_to tag_moments_url :id => moment.id
          elsif params[:operation_type] == "deepen_it"
            redirect_to deepen_moments_path :id => moment.id
          elsif params[:operation_type] == "connect_it"
            redirect_to connect_moments_url :id => moment.id
          else
            redirect_to child_profile_children_path :child_id => moment.child.id
          end
        else 
          redirect_to new_account_url
        end
        
      else
        
      @moment = moment
      @moment_tags = MomentTag.find_all_by_level(nil)
      render :action => :new
        
      end
    else      
      flash[:error] = "Can't create moments for children from someone else's family"      
      redirect_to errors_permission_path
    end   
  end

  def edit
    @moment = Moment.find(params[:id])
    @moment_tags = MomentTag.find_all_by_level(nil)
    logger.info("INFO #{@moment.can_be_viewed? current_user}");
    unless current_user.can_edit_child? @moment.child.id
      redirect_to errors_permission_path
    end
  end

  def update
    moment = Moment.find(params[:id])

    if current_user.can_edit_child? moment.child.id

      media = []
      media += Media.find(params[:uploaded_images_pids]) unless params[:uploaded_images_pids].blank?
      media += MediaFacebook.create_media_objects(params[:facebook_photos], params[:facebook_pids], current_user.id)  unless  params[:facebook_photos].blank?
      media += MediaFlickr.create_media_objects(params[:flickr_photos], params[:flickr_pids], current_user.id)  unless  params[:flickr_pids].blank?
      media += MediaYoutube.create_media_objects(params[:youtube_videos], current_user.id)  unless  params[:youtube_videos].blank?
      media += MediaVimeo.create_media_objects(params[:vimeo_videos], current_user.id)  unless  params[:vimeo_videos].blank?

      moment.media = media

      moment_tags = Array.new
      moment_tags = MomentTag.find(params[:moment_tag_ids]) unless params[:moment_tag_ids].blank?

      moment_tags_to_destroy = moment.moment_tags.main_level - moment_tags
      moment_tags_to_add = moment_tags - moment.moment_tags.main_level

      moment.moment_tags = moment.moment_tags - moment_tags_to_destroy
      moment.moment_tags = moment.moment_tags + moment_tags_to_add

      if moment.update_attributes(params[:moment])
        flash[:notice] = "Moment has been successfuly updated."
        
        log_description = Array.new
        log_description << "MOMENT ##{moment.id} UPDATED:"
        log_description << "Title: #{moment.title}"
        log_description << "Tags: #{(moment.moment_tags.collect {|moment_tag| moment_tag.name}).join(', ')}" unless moment.moment_tags.blank?

        Log.create_log current_user.id, log_description

        if params[:operation_type] == "tag_it"
          redirect_to tag_moments_path :id => moment.id
        elsif params[:operation_type] == "deepen_it"
          redirect_to deepen_moments_path :id => moment.id
        elsif params[:operation_type] == "connect_it"
          redirect_to connect_moments_path :id => moment.id
        else
          redirect_to child_profile_children_url :child_id => moment.child.id
        end
      else

      @moment = moment
      @moment_tags = MomentTag.find_all_by_level(nil)
      render :action => :edit

      end
    else
      redirect_to errors_permission_path
    end
  end

  def destroy
    @moment = Moment.find(params[:id])
    @moment.update_attribute(:visibility, Moment::ARCHIVED)
    log_description = Array.new
    log_description << "MOMENT ##{@moment.id} ARCHIVED:"
    log_description << "Title: #{@moment.title}"
    
    Log.create_log current_user.id, log_description

    redirect_to child_profile_children_path(:child_id => @moment.child.id)
  end

  def tag_moment
    
    @moment = Moment.find(params[:id])

    if current_user.can_edit_child? @moment.child.id
      @main_moment_tags = MomentTag.main_level
    else
      redirect_to errors_permission_path
    end
  end

  def update_moment_tags
    moment = Moment.find(params[:id])
    
    moment_tags = Array.new
    unless params[:moment_tag_ids].blank?
      moment_tags = MomentTag.find(params[:moment_tag_ids])
      moment_tags_ids = Array.new
      moment_tags.each do |moment_tag|
        hierarchy = moment_tag.level_hierarchy
        hierarchy = hierarchy.split(">>")
        moment_tags_ids += hierarchy
        moment_tags_ids = moment_tags_ids.push(moment_tag.id.to_s)
      end
      moment_tags_ids = moment_tags_ids.uniq
      moment_tags = MomentTag.find(moment_tags_ids)
    end
    moment_tags_to_destroy = moment.moment_tags.not_main_level - moment_tags
    moment_tags_to_add = moment_tags - moment.moment_tags.not_main_level
    moment.moment_tags = moment.moment_tags - moment_tags_to_destroy
    moment.moment_tags = moment.moment_tags + moment_tags_to_add
    moment.save
    
    log_description = Array.new
    log_description << "MOMENT ##{moment.id} TAGGED:"
    log_description << "Title: #{moment.title}"
    log_description << "Tags: #{(moment.moment_tags.collect {|moment_tag| moment_tag.name}).join('; ')}" unless moment.moment_tags.blank?

    Log.create_log current_user.id, log_description
    
    flash[:notice] = "Moment Tags have been successfuly updated."
    if params[:operation_type] == "deepen_it"
      redirect_to deepen_moments_url :id => moment.id
    elsif params[:operation_type] == "connect_it"
      redirect_to connect_moments_url :id => moment.id
    else
      redirect_to tag_moments_url :id => moment.id
    end
  end

  def deepen_it
    @moment = Moment.find(params[:id])
    unless current_user.can_edit_child? @moment.child.id
      redirect_to errors_permission_path
    end
  end

  def update_deepen_it
    moment = Moment.find(params[:id])
    
    if moment.update_attributes(params[:moment])

      flash[:notice] = "Moment have been successfuly updated."
      if params[:operation_type] == "tag_it"
        redirect_to tag_moments_url :id => moment.id
      elsif params[:operation_type] == "connect_it"
        redirect_to connect_moments_url :id => moment.id
      else
        redirect_to deepen_moments_url :id => moment.id
      end
    
    else

      flash[:error] = "Something goes wrong. Try one more time"
      redurect_to deepen_moments_url :id => moment.id

    end
  end

  def connect_it
    @moment = Moment.find(params[:id])
    if current_user.can_edit_child? @moment.child_id


      all_child_moments_ids = Moment.ids.where(:child_id => @moment.child_id)
      all_child_moments_ids = ((all_child_moments_ids.select { |moment_id| moment_id.id != @moment.id}).collect { |moment| moment.id}).join(", ")
      current_moment_tag_ids = ((MomentTagsMoments.moment_tag_ids.where(:moment_id => @moment.id)).collect { |moment_tag| moment_tag.moment_tag_id }).join(", ")
      
      #bulding_query
      unless all_child_moments_ids.blank?
        query = "SELECT * FROM moments LEFT JOIN ( SELECT moment_id, moment_tag_id, count(*) as count FROM moment_tags_moments WHERE moment_id IN (#{all_child_moments_ids}) "
        unless current_moment_tag_ids.blank?
          query += "AND moment_tag_id IN (#{current_moment_tag_ids}) "
        end
        query += "GROUP BY moment_id ORDER BY count DESC ) AS moment_tags_count ON (moment_tags_count.moment_id = id) WHERE id NOT IN ('#{@moment.id}') AND moments.visibility NOT IN ('#{Moment::ARCHIVED}') AND moments.child_id = #{@moment.child_id} ORDER BY count DESC LIMIT 40"
        count_moment_ids = Moment.find_by_sql(query)
      else
        count_moment_ids = false;
      end
      

      @moments = count_moment_ids

    else
      redirect_to errors_permission_path
    end
  end

  def update_connect_it
    moment = Moment.find(params[:id])

    params[:related_moment].blank? ? connected_moments = [] : connected_moments = Moment.find(params[:related_moment])
    connected_moment_children_difference = moment.connected_moment_children - connected_moments
    moment.connected_moment_children = connected_moments
    connected_moments.each do |connected_moment|
      connected_moment.connected_moment_children << moment
    end

    connected_moment_children_difference.each do |difference_moment|
      difference_moment.connected_moment_children = difference_moment.connected_moment_children - difference_moment.connected_moment_children.where(["moment_connections.connected_child_id = ?", moment.id])
    end

    log_description = Array.new
    log_description << "MOMENT ##{moment.id} CONNECTED:"
    log_description << "Title: #{moment.title}"
    moment.connected_moment_children.each do |connected_moment|
      log_description << "Connected: #{connected_moment.title}"
    end
    connected_moment_children_difference.each do |difference_moment|
      log_description << "Disconneted: #{difference_moment.title}"
    end
    Log.create_log current_user.id, log_description

    if params[:operation_type] == "tag_it"
      redirect_to tag_moments_url :id => moment.id
    elsif params[:operation_type] == "deepen_it"
      redirect_to deepen_moments_url :id => moment.id
    else
      redirect_to connect_moments_url :id => moment.id
    end
  end

  def change_provider
    
    render :partial => "facebook/select_facebook_photos" if params[:provider] == 'facebook'
    render :partial => "flickr/select_flickr_photos" if params[:provider] == "flickr"
    render :partial => "uploaded_images/select_uploaded_images" if params[:provider] == 'uploaded-images'
    render :partial => "youtube/select_youtube_videos" if params[:provider] == 'youtube'
    render :partial => "vimeo/multiselect_vimeo_videos" if params[:provider] == 'vimeo'
    
  end

  def import_media

    if current_user.can_edit_child? params[:child_id]
      family_children = my_family.children
      @selected_child = (family_children.select { |child| child.id.to_s == params[:child_id].to_s }).first
      @next_child = family_children.at((family_children.index { |child_item| child_item.id == @selected_child.id })+1)
    else
      redirect_to errors_permission_path
    end
    
  end

  def import_videos

    if current_user.can_edit_child? params[:child_id]
      
      @family_children = my_family.children
      @selected_child = Child.find(params[:child_id])
      @next_child = @family_children.at((@family_children.index { |child_item| child_item.id == @selected_child.id })+1)
      
    else
      
      redirect_to errors_permission_path
      
    end
    
  end

  def create_from_media
    
    media = []
    titles = params[:media_titles]
    media += Media.find(params[:uploaded_images_pids]) unless params[:uploaded_images_pids].blank?    
    media += MediaFacebook.create_media_objects(params[:facebook_photos], params[:facebook_pids], current_user.id)  unless  params[:facebook_photos].blank?    
    media += MediaFlickr.create_media_objects(params[:flickr_photos], params[:flickr_pids], current_user.id)  unless  params[:flickr_pids].blank?
    media += MediaYoutube.create_media_objects(params[:youtube_videos], current_user.id)  unless  params[:youtube_videos].blank?
    media += MediaVimeo.create_media_objects(params[:vimeo_videos], current_user.id)  unless  params[:vimeo_videos].blank?
     
    moments = []

    child = Child.find(params[:child_id])
    media_ids = (child.moments.collect { |moment_item| moment_item.media.collect { |media_item| media_item.id } }).flatten
     
    media.each_with_index do |m, idx|
      unless media_ids.include?(m.id)
        mom = Moment.new
        mom.media << m
        mom.child = child
        mom.title = titles[idx]
        mom.save
        moments << mom
      end
    end

    @family_children = my_family.children
    @selected_child = @family_children.at((@family_children.index { |child_item| child_item.id.to_s == params[:child_id].to_s })+1)
    if @selected_child.nil?
      redirect_to child_profile_children_path
    else

      next_child = @family_children.at((@family_children.index { |child_item| child_item.id == @selected_child.id })+1)
      next_child.nil? ? @next_child_name = "Save & Finish" : @next_child_name = "Go to #{next_child.first_name.capitalize}"
      
      render :action => :import_media
    end
     
  end

end
