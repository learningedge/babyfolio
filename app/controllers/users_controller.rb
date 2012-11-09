class UsersController < ApplicationController
    
  before_filter :require_user, :only => [:show, :edit, :update, :add_image, :upload, :settings, :update_password]
  before_filter :require_child, :only => [:settings]
  skip_before_filter :require_confirmation, :only => [:new, :create, :create_temp_user]    

  def new    
    if !current_user and session[:temporary_user_id]
      @user = User.find(session[:temporary_user_id])
      @user.email = ''
      @user.first_name = ''
      @user.last_name = ''
    else
      clear_session
      @user = User.new
    end
    @accept_terms = false
  end

  def create
    if session[:temporary_user_id]
      @user = User.find(session[:temporary_user_id])
      @user.update_attributes(params[:user])      
    else
      @user = User.new(params[:user])      
      @user.reset_single_access_token
    end

    @user.reset_perishable_token
    @user.profile_media = Media.find_by_id(params[:user_profile_media])
    
    if @user.valid?
      @user.email_confirmed = false
      @user.save      
      UserMailer.confirmation_email(@user).deliver

      flash[:notice] = "Your account has been created. Confirmation email has been sent."
      redirect_to new_child_children_url
    else
      flash[:notice] = "There was a problem creating your account."
      render :action => :new
    end
  end

  def create_profile_photo
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
      format.html { render :text => "{\"success\":\"true\", \"media_id\":\"#{media.id}\", \"img_url\":\"#{media.image.url(:upload_med)}\"}" }
    end
  end

  def settings
    if current_child
      @current_relation = current_child.relations.find_by_user_id(current_user.id)
      @invited_by_me = Relation.find_all_by_inviter_id_and_accepted_and_child_id(current_user.id, [0, 1], current_child.id, :include => [:child, :inviter])
    end
    @pending_invitations = current_user.relations.find_all_by_accepted(0, :include => [:user, :child])
     
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
    @user = current_user
    @user.profile_media = Media.find_by_id(params[:user_profile_media])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to settings_path
    else
      render :action => :edit
    end
  end

  def update_password
    @user = current_user    
        
    password = "#{params[:current_password]}#{@user.password_salt}"
    @password = Authlogic::CryptoProviders::Sha512.encrypt(password)
    if @password == @user.crypted_password
      @password_ok = true
    end

    @user.add_object_error("Your current password doesn't match") unless @password_ok
    @user.errors.add(:password, "can't be blank") if params[:user][:password].blank?    
    
    respond_to do |format|
      if @user.errors.blank? && @user.update_attributes(params[:user])
        format.js { render :partial => "change_password_success" }
      else
        format.html { render :partial => "change_password", :locals => {:user => current_user } }
      end
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

  def create_temp_user
    y = params[:birth_year].to_i if params[:birth_year].present?
    m = params[:birth_month].to_i if params[:birth_month].present?
    d = params[:birth_day].to_i if params[:birth_day].present?
   
    date = DateTime.new(y, m, d) if DateTime.valid_date?(y,m,d) if d && m && y
    gender = params[:gender] || Child::GENDERS['Male']
    ft = params[:form_type]

    if ft.nil? && date.nil?
      flash[:notice] = "Incorrect child's birth date."
      redirect_to root_url
      return
    end
    
    unless current_user
        if date || ft.present?
          timeStamp =  DateTime.now.to_f.to_s
          new_user = User.new({
                  :first_name => 'Temporary',
                  :last_name => 'User',
                  :email => timeStamp + '@babyfolio.com',
                  :email_confirmed => true,
                  :password => timeStamp,
                  :password_confirmation => timeStamp,
                  :is_temporary => true
          })

          new_user.reset_perishable_token
          if new_user.save
            family = Family.create({:name => Family::DEFAULTS[:family_name], :zip_code => Family::DEFAULTS[:zipcode] })
            child = family.children.build({:first_name => Child::DEFAULTS[:first_name], :last_name => family.name, :birth_date => date || DateTime.now , :gender => gender  })
            family.save

            new_user.relations.build({ :family => family, :member_type => Relation::MEMBER_TYPE[:PARENT], :accepted => true, :display_name => "TheParent", :token => timeStamp })
            if new_user.save
              session[:temporary_user_created] = true
              UserSession.new(new_user)
            else
              flash[:notice] = "There were some errors creating temporary account."
            end
         else
           flash[:notice] = "There were some errors creating temporary account."
         end
      end
    else
      if ft.blank?
        flash[:notice] = "You have your profile already."
      end
      child = current_user.own_children.first
    end

    unless ft.blank?
      redirect_to child_new_moment_url(:child_id => child.id )
    else      
      redirect_to questions_url(:child => child.id, :level => 'basic' )
    end
  end
  
end
