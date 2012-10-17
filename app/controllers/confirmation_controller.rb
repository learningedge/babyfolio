class ConfirmationController < ApplicationController

  skip_before_filter :require_confirmation
  before_filter :require_user, :only => [:index, :re_send_email]
  before_filter :require_no_confirmation, :only => [:index, :re_send_email]

  def index
    @user = current_user
    UserMailer.confirmation_email(@user).deliver
  end

  def re_send_email
    @user = current_user
    UserMailer.confirmation_email(@user).deliver
    render :index
  end

  def confirm_email
    @token = params[:token]
    @user = User.find_by_perishable_token @token
    if @user.nil?
      flash[:error] = "We can't find the user, try resending email"
      current_user_session.destroy if current_user_session
      reset_session
      redirect_to confirmation_path
    else
      @user.email_confirmed = 1
      @user.save
      UserSession.create(@user)
      @user.reset_perishable_token!
      flash[:notice] = "Email successfuly confirmed."
      redirect_to child_profile_children_url      
    end
  end



  def accept_invitation    
    @relation = Relation.find_by_token(params[:token], :include => [:user])
    @user = @relation.user
    @edit = true
    UserSession.create(@relation.user)
    if @user.email_confirmed
      @relations = Relation.find_all_by_user_id_and_accepted(@user.id, [0,2], :include => [:child, :user])
      render :accept_relations
    end
    
    rescue NoMethodError
      flash[:notice] = "Ooops, there is something wrong with your invitation."
      redirect_to login_url
  end

  def accept_relations     
  end

  def save_relations
    if params[:accepted].present?
      accepted_tokens = params[:accpeted].map{|k,v| v}
      accepted_rels = Relation.find_all_by_token(accepted_tokens)

      accepted_rels.each do |r|
        r.update_attribute(:accepted, 1)
      end
    end

    if params[:declined].present?
      declined_tokens = params[:declined].map{|k,v| v}
      declined_rels = Relation.find_all_by_token(declined_tokens)

      declined_rels.each do |r|
        r.update_attribute(:accepted, 2)
      end
    end
    
    

    
    

    

    

    redirect_to child_profile_children_url
  end

  def update_user    
    @relation = Relation.find_by_token(params[:token], :include => [:user])
    @user = @relation.user
    @edit = true

    @user.profile_media = Media.find_by_id(params[:user_profile_media])
    @user.assign_attributes(params[:user])
      
     if @user.valid?
        @user.email_confirmed = true
        @user.save        
        flash[:notice] = "Your settings has been sucessfully updated."
        @relations = Relation.find_all_by_user_id_and_accepted(@user.id, [0,2],:include => [:child, :user])
        render :accept_relations
    else
        flash[:notice] = "There was a problem with creating your account."
        render :accept_invitation
    end
     
  end

  private

  def require_no_confirmation
    if current_user.email_confirmed
      redirect_to child_profile_children_url
      flash[:notice] = "Your email is confirmed already."
    end
  end

end
