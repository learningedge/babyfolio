class ApplicationController < ActionController::Base
  protect_from_forgery

  config.filter_parameters :password, :password_confirmation
  helper_method :current_user_session, :current_user, :current_family, :my_family

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
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
        redirect_to child_profile_children_url
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

    def require_confirmation
      @current_user = current_user
      unless @current_user.email_confirmed
        redirect_to confirmation_url
      end
    end

    def require_my_family
      @current_user = current_user
      unless @current_user.is_parent?
        redirect_to new_family_url
      end      
    end

    def current_family
      return @current_family if defined?(@current_family)
      if session[:current_family]
        return @current_family = Family.find(session[:current_family])
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

    def require_no_family
      redirect_to child_profile_children_url if current_family
    end

end


