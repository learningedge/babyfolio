class ApplicationController < ActionController::Base
  protect_from_forgery  
  before_filter :confirm_account_from_link

  config.filter_parameters :password, :password_confirmation
  helper_method :current_user_session, :current_user, :get_return_url_or_default, :current_child, :set_current_child, :category_name
#  before_filter :authenticate

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
        redirect_to login_url
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

    def current_child
      return @current_child if defined?(@current_child)
      if session[:current_child]
        @current_child = current_user.children.find_by_id(session[:current_child]);
      else
        @current_child = current_user.children.first if current_user.children.present?
        set_current_child @current_child.id if @current_child
      end
      @current_child
    end

    def set_current_child child_id
      session[:current_child] = child_id
      @current_child = Child.find_by_id(child_id);
    end

    def require_child
      redirect_to registration_new_child_path unless current_child
    end

    def require_seen_behaviours
        redirect_to registration_initial_questionnaire_path if current_child.answers.where(:value => 'seen').count == 0
    end

    def category_name(str)
      Question::CATS[str]
    end


    def confirm_account_from_link
      if params[:confirm].present? && params[:token].present?
        user = User.find_by_persistence_token(params[:token])
        if user
          unless user.email_confirmed
            user.update_attribute(:email_confirmed, true)
            UserSession.create(user)
            store_location
            redirect_to email_confirmed_path
          end
        end
      end
    end


    def serialization_scope
      current_user
    end

end


