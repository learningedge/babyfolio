class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :clear_family_registration
  before_filter :require_confirmation

  config.filter_parameters :password, :password_confirmation
  helper_method :current_user_session, :current_user, :current_family, :my_family, :youtube_user, :flickr_images, :get_return_url_or_default, :family_registration?, :user_is_parent?, :current_child, :set_current_child, :category_name

before_filter :authenticate

protected

def authenticate
  authenticate_or_request_with_http_basic do |username, password|
    username == "bf" && password == "bfdev"
  end
end

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
        @current_child = current_user.children.first if current_user.children
        set_current_child @current_child.id if @current_child
      end
      @current_child
    end

    def set_current_child child_id
      session[:current_child] = child_id
      @current_child = Child.find_by_id(child_id);
    end

    def require_child
      redirect_to new_child_children_path unless current_child
    end


    def category_name(str)
      Question::CATS[str]
    end

end


