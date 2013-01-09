class HomeController < ApplicationController

  layout 'child', :only => [:about, :contact, :privacy]
  
  skip_before_filter :clear_family_registration
  skip_before_filter :require_confirmation
  
  def index
    redirect_to show_timeline_path if current_user
    @user_session = UserSession.new
  end

  def about    
  end

  def privacy    
  end

  def contact
    @contact = ContactMessage.new
  end

  def send_contact
    @contact = ContactMessage.new(params[:contact_message])
    respond_to do |format|
      if @contact.valid?
        UserMailer.send_contact(@contact).deliver
        format.html { render :partial => "message_sent"}
      else
        format.html { render :partial => "contact_form"}
      end
    end
  end

end
