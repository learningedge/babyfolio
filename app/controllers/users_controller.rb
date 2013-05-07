class UsersController < ApplicationController

  layout "child", :only => [:settings, :edit]
  before_filter :require_user, :only => [:show, :edit, :update, :add_image, :upload, :settings, :update_password]
  before_filter :require_family, :only => [:settings]
  skip_before_filter :require_confirmation, :only => [:new, :create, :create_temp_user]
  before_filter :require_seen_behaviours, :only => [:settings]

  def new        
    @page = Page.find_by_slug("signup_step_1")
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
      @page = Page.find_by_slug("signup_step_1")
      render :action => :new
    end
  end

  def update_temporary
    @user = current_user
    @user.first_name = ''
    @user.last_name = ''
    @user.email = ''   
    
    @user.profile_media = Media.find_by_id(params[:user_profile_media]) if params[:user_profile_media].present?
    
    if params[:user]
      @user.assign_attributes(params[:user])
      
      if @user.valid?
        @family = current_child.family
        family_name, family_full_name = Family.get_family_name_format @user
        @family.name = family_name
        @family.full_name = family_full_name
        @family.save        

        @user.user_actions.new(:title => "account_created")
        @user.email_confirmed = false
        @user.is_temporary = false
        @user.save

        TimelineEntry.generate_initial_timeline_entires current_child, @user
        @user.create_initial_actions_and_emails current_child
        
        redirect_to child_reflect_children_path
        return
      end
    end
    
    @page = Page.find_by_slug("signup_step_1")
    render :action => :new
  end


  def deactivate_user
    @user_name = current_user.get_user_name
    @user_email = current_user.email

    current_user.destroy_user
    clear_session

    respond_to do |format|
      format.html { render :partial => "deactivate_user_survey" }
    end
    
  end

  def deactivate_user_survey
    email_data = {
      :user_name => params[:user_name],
      :user_email => params[:user_email],
      :why_leave => params[:why_leave],
      :what_different => params[:what_different],
      :other_feedback => params[:other_feedback]
    }                    

    UserMailer.account_deactivation(email_data).deliver
    UserMailer.account_deactivation_survey(email_data).deliver
    respond_to do |format|
      format.html { render :partial => "deactivate_final_message" }
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
    redirect_to settings_path(:family_id => params[:family_id])
  end

  def settings 
    @page = Page.find_by_slug("settings")
    @very_own_family = current_user.get_first_very_own_family

    unless params[:is_about_me]
      @family = current_user.families.find_by_id(params[:family_id])
      @family = current_user.select_first_family unless @family
      @is_admin = @family.is_admin?(current_user)
      @is_family_admin = @very_own_family && @family.id == @very_own_family.id      
    else
      @family = @very_own_family
      @is_family_admin = true if @family
    end

    case flash[:tab]
        when "my_family"
          @current_tab = 1
        when "family-friends-information"
          @current_tab = @is_admin ? 2 : 1
        else
          @current_tab = 0
    end
    
    if @is_admin || @is_family_admin
      @children = current_user.children.where('children.family_id' => @family.id).all

      @family_admin_users = @family.admin_relations.includes(:user).where(['relations.user_id != ?', current_user.id]).uniq_by{|r| r.user.id}
      @family_member_users = @family.member_relations.includes(:user).where(['relations.user_id != ?', current_user.id]).uniq_by{|r| r.user.id}

      @children_access = {}
      (@family_admin_users.map{|r| r.user} + @family_member_users.map{|r| r.user}).uniq.each do |user|
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
      redirect_to settings_about_path
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
    current_user_session.destroy if current_user_session
    reset_session
    
    y = m = d = 0;

    if params[:date]
      y = params[:date][:year].to_i if params[:date][:year].present?
      m = params[:date][:month].to_i if params[:date][:month].present?
      d = params[:date][:day].to_i if params[:date][:day].present?
    end
   
    date = DateTime.new(y, m, d) if DateTime.valid_date?(y,m,d) if d && m && y
    gender = params[:gender] || Child::GENDERS['Male']
    form_type = params[:form_type]

    if (form_type.nil? && date.nil?) || date > Time.now
      flash[:notice] = "Incorrect child's birth date."
      redirect_to root_url
      return
    end
    
    unless current_user
        if date || form_type.present?
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
            child = Child.new({:first_name => Child::DEFAULTS[:first_name], :last_name => Child::DEFAULTS[:last_name], :birth_date => date || DateTime.now , :gender => gender  })
            child.save

            set_current_child child.id

            Family.user_added_child(new_user, child, Relation::TYPE_KEYS[0], nil, nil)

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
      if form_type.blank?
        flash[:notice] = "You have your profile already."
      end
      child = current_user.own_children.first
    end

    unless form_type.blank?
      redirect_to child_new_moment_url(:child_id => child.id )
    else      
      redirect_to registration_initial_questionnaire_url
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
