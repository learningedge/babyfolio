class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :clear_family_registration
  before_filter :require_confirmation

  config.filter_parameters :password, :password_confirmation
  helper_method :current_user_session, :current_user, :current_family, :my_family, :youtube_user, :flickr_images, :get_return_url_or_default, :family_registration?, :user_is_parent?, :current_child, :set_current_child, :category_name

  private
    def clear_session
      if current_user_session
        current_user_session.destroy        
        @current_user = nil
        reset_session        
      end
    end

    def clear_family_registration
      session[:is_registration] = nil
    end

    def family_registration?
      session[:is_registration] || false
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def current_user?
      defined?(@current_user)
    end

    def require_admin
      true if require_user and current_user.is_admin
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to home_index_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def get_return_url_or_default(default)
      back_url =  session[:return_to] || default
      session[:return_to] = nil
      back_url
    end

    def require_confirmation
      if current_user and !current_user.email_confirmed and current_user.created_at < (DateTime.now - 7.days)
        redirect_to confirmation_url
      end
    end

    def current_child
      return @current_child if defined?(@current_child)
      if session[:current_child]
        @current_child = Child.find_by_id(session[:current_child]);
      else
        @current_child = current_user.children.first 
        set_current_child @current_child.id if @current_child
      end
      @current_child
    end

    def set_current_child child_id
      session[:current_child] = child_id
      @current_child = Child.find_by_id(child_id);
    end

    def require_child
      redirect_to new_child_children_path unless current_user.children.any?
    end

    def current_family
      return @current_family if defined?(@current_family) and @current_family.id == session[:current_family]
      if session[:current_family]
        return @current_family = current_user.families.find_by_id(session[:current_family])
      else
        @current_family = current_user.main_family
        session[:current_family] = @current_family.id if @current_family
        return @current_family
      end
    end

    def my_family
      return @my_family if defined?(@my_family)
      if current_user.families.parenting_families.exists? session[:current_family]
        @my_family = current_family
      else
        session[:current_family] = current_user.families.parenting_families.first
        @my_family = current_family
      end
    end

    def require_family
      redirect_to new_family_url unless current_family
    end

    def require_my_family
      @current_user = current_user
      unless @current_user.is_parent?
        redirect_to new_family_url
      end      
    end

    def require_family_with_child
      unless current_user.relations.accepted.find_by_family_id(current_family.id) && current_family.children.exists? 
	family_with_child = current_user.first_family_with_child
	if family_with_child.blank?
          flash[:error] = "The #{current_family.name}'s family doesn't have any children"
	  redirect_to edit_families_path
	  return
        else
          session[:current_family] = family_with_child.id
	end
      end
    end

    def require_no_family
      redirect_to child_profile_children_url if current_family
    end

    def user_is_parent?
      return  true if current_family.relations.is_parent.find_by_user_id(current_user.id)
      false
    end
    
    def require_parent
      unless user_is_parent?
        flash[:error] = "That action requires you to be a parent of the family.";
        redirect_back_or_default family_relations_families_url
      end
    end
    

    def youtube_user

      return @youtube_user if defined?(@youtube_user)

      unless current_user.services.youtube.empty?
        youtube = current_user.services.youtube.first
        @youtube_user = YouTubeIt::OAuthClient.new(
                                                   :consumer_key => '821905120152.apps.googleusercontent.com', 
                                                   :consumer_secret => 'q9XDXCtGECoa0clbFMeVGuKT', 
                                                   :client_id => youtube.uid, 
                                                   :dev_key => "AI39si5CBu2pCYdFlu9nRI5ATwxqvUHm3vlw2MR4qD42DjXRS-UkGhXhai1oT7V4DBt8OJmQn9h6qzfX7OsggfcMf-8luMew4w")
        @youtube_user.authorize_from_access(youtube.token, youtube.secret)

        return @youtube_user
      end
    end

    def category_name(str)
      Question::CATS[str]
    end

end


