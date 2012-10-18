class ChildrenController < ApplicationController

  before_filter :require_user
  before_filter :require_child, :except => [:new,:create,:create_childs_photo]

  def new
    @child = Child.new    
  end

  def create
    @child = Child.new(params[:child])
    @child.media = MediaImage.find_by_id(params[:child_profile_media])

    if @child.save      
      rel = Relation.find_or_create_by_user_id_and_child_id(current_user.id, @child.id)
      rel.assign_attributes(:member_type => params[:relation_type], :accepted => 1, :token => current_user.perishable_token)
      rel.save
      current_user.reset_perishable_token!            
      set_current_child @child.id
      redirect_to initial_questionnaire_url
    else
      render :action => 'new'
    end
  end

  def create_childs_photo
    if params[:qqfile].kind_of? String
      ext = '.' + params[:qqfile].split('.').last
      fname = params[:qqfile].split(ext).first
      tempfile = Tempfile.new([fname, ext])
      tempfile.binmode
      tempfile << request.body.read
      tempfile.rewind
    else
      tempfile = params[:qqfile].tempfile
    end

    media = MediaImage.create(:image => tempfile)
    respond_to do |format|
      format.html { render :text => "{\"success\":\"true\", \"media_id\":\"#{media.id}\", \"img_url\":\"#{media.image.url(:medium)}\"}" }
    end
  end

  def show
    @user = current_user
    @children = current_user.relations.find_all_by_accepted(1, :conditions => ['child_id is not null'], :include => [:child]).map{|r| r.child}
    if session[:level] && session[:level][@selected_child.id]
      @level = session[:level][@selected_child.id]
    end

    @selected_child = @children.select{|c| c.id == params[:child_id].to_i }.first
    if @selected_child.present?
      set_current_child @selected_child.id
    else
      @selected_child = current_child
    end
    moments = @selected_child.moments

    @moments = moments.paginate(:page => params[:page])
  end

  def edit
    @child = Child.find(params[:id])    
  end

  def update

    if !params[:flickr_photos].blank?
      media_element = MediaFlickr.create_media_objects(params[:flickr_photos].first, params[:flickr_pids].first, current_user.id)
    elsif !params[:facebook_photos].blank?
      media_element = MediaFacebook.create_media_objects(params[:facebook_photos].first, params[:facebook_pids].first, current_user.id)
    elsif !params[:uploaded_images_pids].blank?
      media_element = Media.find(params[:uploaded_images_pids].first)
    end

    @child = Child.find(params[:id])
    @child.media = media_element
    @child.save

    redirect_to child_profile_children_url
  end

  def add_friends
  end

  def add_family
  end

  def create_relations    
    @friends = params[:friends]
    user_emails = Array.new
    users = Array.new
    @error = false

    @friends = @friends.select{ |f| f[1]['email'].strip.present?}
    user_emails = @friends.map{|f| f[1]['email']}.uniq

    
    if user_emails.empty?
      @error = true
      @flash_error = "You need to enter at least one email";
    end

    unless @error
      exist_users = User.where(['email IN (?)', user_emails]).all      

      @friends.each do |f|
        idx = exist_users.find_index{|u| u.email == f[1]['email']}
        if idx
          @user = exist_users[idx]
        else
          @user = User.new(:email => f[1][:email])
          @user.reset_password
          @user.reset_perishable_token
          @user.reset_single_access_token
        end

        unless @user.valid?
            @error = true
            break
        end        
        @user.relations.find_or_initialize_by_child_id(current_child.id, :member_type => f[1][:member_type], :token => @user.perishable_token)
        @user.reset_perishable_token
        users << @user
      end
    end
    
    unless @error
      users.each do |user|
        user.save
        UserMailer.invite_user(user.relations.first{|r| r.child_id == current_child.id}, current_user).deliver
      end
      flash[:notice] = "Thanks fo inviting others. We have successfully sent emails to the other family & friends that you entered."
      redirect_to child_profile_children_path
    else
      flash[:error] = "Invalid emails!"
      render :action => :add_friends
    end
  end


  def info
    if current_user.can_view_child? params[:id]
      @child = Child.find(params[:id])
    else
      respond_to do |format|
        format.html { redirect_to errors_permission_path }
      end
    end
  end
  
end
