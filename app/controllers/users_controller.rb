class UsersController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :add_image, :upload]
  before_filter :require_confirmation, :only => [:show, :edit, :update, :add_image, :upload]
  before_filter :require_family, :only => [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.reset_perishable_token
    @user.reset_single_access_token
    
    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @user.save

      UserMailer.confirmation_email(@user).deliver

      flash[:notice] = "Your account has been created."
      redirect_to confirmation_url
    else
      flash[:notice] = "There was a problem creating your account."
      render :action => :new
    end
    
  end

  def show
    @user = current_user

    @families = @user.families
    @selected_family = current_family
        
    @children = @selected_family.children
    @selected_child = params[:child_id].present? ? (@children.select { |c| c.id == params[:child_id].to_i }.first || @children.first) : @children.first    
    
  end

  def edit
    @user = current_user
    @edit = true
  end

  def update
    @edit = true
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def add_image
    @user = current_user
  end

  def upload_image
    
    if !params[:flickr_photos].blank?
      media_element = MediaFlickr.create_media_objects(params[:flickr_photos].first, params[:flickr_pids].first, current_user.id)
    elsif !params[:facebook_photos].blank?
      media_element = MediaFacebook.create_media_objects(params[:facebook_photos].first, params[:facebook_pids].first, current_user.id)
    elsif !params[:uploaded_images_pids].blank?
      media_element = Media.find(params[:uploaded_images_pids].first)
    end

    @user = current_user
    @user.profile_media = media_element
    @user.save

    redirect_to edit_account_url
  end

end
