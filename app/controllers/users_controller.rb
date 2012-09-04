class UsersController < ApplicationController
    
  before_filter :require_user, :only => [:show, :edit, :update, :add_image, :upload]
  skip_before_filter :require_confirmation, :only => [:new, :create, :create_temp_user]  
  before_filter :require_family, :only => [:show]
#  before_filter :reset_session, :only => [:new]


  def new    
    if !current_user and session[:temporary_user_id]
      @user = User.find(session[:temporary_user_id])
      @user.email = ''
      @user.first_name = ''
      @user.last_name = ''
    else
      @user = User.new
      clear_session
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
    @accept_terms = params[:accept_terms] || false
    
    if @user.valid?
      unless params[:accept_terms]
        @user.add_object_error('You need to accept terms of service before proceeding')
        flash[:notice] = "There was a problem creating your account."
        render :action => :new
      else
#        if session[:child_birth_date].present? && session[:child_gender].present?
#          @user.child_info = {:gender => session[:child_gender], :birth_date => session[:child_birth_date] }
#          session[:child_birth_date] = nil
#          session[:child_gender] = nil
#        end
        
        @user.save
        @user.update_attribute(:email_confirmed, false)
        UserMailer.confirmation_email(@user).deliver

        flash[:notice] = "Your account has been created. Confirmation email has been sent."
        redirect_to new_family_url
        #redirect_to confirmation_url
      end
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
      redirect_to child_profile_children_url
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
