class UsersController < ApplicationController

  layout "child", :only => [:settings, :edit]
  before_filter :require_user, :only => [:show, :edit, :update, :add_image, :upload, :settings, :update_password]
  before_filter :require_family, :only => [:settings]
  skip_before_filter :require_confirmation, :only => [:new, :create, :create_temp_user]
  before_filter :require_seen_behaviours, :only => [:settings]

  def new        
    clear_session
    @user = User.new
  end

  def create    
    @user = User.new(params[:user])    
    @user.reset_single_access_token

    @user.reset_perishable_token
    @user.profile_media = Media.find_by_id(params[:user_profile_media]) if params[:user_profile_media].present?
    
    if @user.valid?
      @user.email_confirmed = false
      @user.user_actions.new(:title => "account_created")
      @user.save      
      redirect_to registration_new_child_path
    else
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
      format.html { render :text => "{\"success\":\"true\", \"media_id\":\"#{media.id}\", \"img_url\":\"#{media.image.url(:profile_medium)}\"}" }
    end
  end

  def settings_tab
    flash[:tab] = params[:tab]
    redirect_to settings_path
  end

  def settings
    @family = current_family
    @is_admin = @family.is_admin?(current_user)

    if @is_admin
      @children = current_user.children.where('children.family_id' => @family.id).all

      @family_admin_users = @family.admin_relations.includes(:user).where(['relations.user_id != ?', current_user.id]).uniq_by{|r| r.user.id}
      @family_member_users = @family.member_relations.includes(:user).where(['relations.user_id != ?', current_user.id]).uniq_by{|r| r.user.id}

      @children_access = []
      (@family_admin_users.map{|r| r.user} + @family_member_users.map{|r| r.user}).each do |user|
        @children_access[user.id] = user.relations.joins(:child).where({"children.family_id" => @family.id}).all
      end

      @awaiting_family_invitations = @family.awaiting_relations.includes(:user).uniq_by{|r| r.user_id}
    end
    
    @all_children_relations = current_user.accessible_relations.includes([:child => :family]).where('relations.inviter_id IS NOT NULL').group_by{|r| r.child.family.name}
    @my_pending_invitations = current_user.relations.includes([:child, :user]).find_all_by_accepted(0).uniq_by{|r| r.child.family_id}
    
    
    case flash[:tab]
      when "my_family"
        @current_tab = 1
      when "family-friends-information"
        @current_tab = @is_admin ? 2 : 1
      else
        @current_tab = 0
    end
    @current_tab = 3 if params[:is_invite] && @is_admin
    
    @invitation_emails = []
    Relation::TYPE_KEYS.each do |k|
      @invitation_emails << {:email => '', :type => k, :error => nil }
    end
    render :template => "users/settings/settings"
  end

  def update_options    
  end

  def update_zipcode
    current_user.zipcode = params[:zipcode] if params[:zipcode].present?
    current_user.save    
    redirect_to params[:return_url]
  end

  def edit
    @user = current_user
    @edit = true
  end

  def update
    @edit = true
    @user = current_user    
    @user.profile_media = Media.find_by_id(params[:user_profile_media]) if params[:user_profile_media].present?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to settings_path
    else
      render :action => :edit
    end
  end

  def update_password
    @user = current_user    
        
    password = "#{params[:user][:current_pass]}#{@user.password_salt}"
    @password = Authlogic::CryptoProviders::Sha512.encrypt(password)
    if @password == @user.crypted_password
      @password_ok = true
    end

    @user.errors.add(:current_pass, "doesn't match") unless @password_ok
    @user.errors.add(:password, "can't be blank") if params[:user][:password].blank?

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    
    respond_to do |format|
      if @user.errors.blank? && @user.save
        format.html { render :partial => "change_password_success" }
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

            new_user.relations.build({ :family => family, :member_type => "Father", :accepted => true, :display_name => "TheParent", :token => timeStamp })
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

  def unsubscribe
    @user = User.find_by_persistence_token(params[:token])
    if @user
      @user.user_option.subscribed = false
      @user.save
    else
      render :text => "<h4>There were some errors unsubscribing.</h4>", :layout => true
    end
  end
  
end
