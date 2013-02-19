class ApplicationController < ActionController::Base
  protect_from_forgery  
  before_filter :confirm_account_from_link

  config.filter_parameters :password, :password_confirmation
  helper_method :current_user_session, :current_user, :get_return_url_or_default, :current_child, :set_current_child, :current_family, :set_current_family, :category_name
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

    # ============================
    # ====== USER METHODS ========
    # ============================
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

    # ==========================
    # ===== FAMILY METHODS =====
    # ==========================
    def current_family      
      return @current_family if defined?(@current_family)
      if session[:current_family]
        @current_family = current_user.families.find_by_id(session[:current_family])
      else
        @current_family = current_user.own_families.first if current_user.own_families.any?
        @current_family ||= current_user.families.first if current_user.families.any?
        set_current_family(@current_family.id) if @current_family
      end
      @current_family
    end

    def set_current_family(family_id)
      session[:current_family] = family_id
      @current_family = current_user.families.find_by_id(family_id);
    end

    def require_family
      #redirect_to registration_new_child_path unless current_family
    end

    # ===============================
    # ======== CHILD METHODS ========
    # ===============================
    def current_child
      return @current_child if defined?(@current_child)
      if session[:current_child]
        @current_child = current_user.children.find_by_id(session[:current_child]);
      else
        @current_child = current_user.own_children.first if current_user.own_children.any?
        @current_child = current_user.other_children.first if @current_child.nil? && current_user.other_children.any?
        set_current_child @current_child.id if @current_child
      end
      @current_child
    end

    def set_current_child child_id
      session[:current_child] = child_id
      @current_child = Child.find_by_id(child_id);
      set_current_family(@current_child.family_id)
    end

    def clear_current_child
      session[:current_child] = nil
      @current_child = nil
    end

    def require_child
      redirect_to registration_new_child_path unless current_child
    end

    # ==============================
    # ====== LOCATION METHODS ======
    # ==============================
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


