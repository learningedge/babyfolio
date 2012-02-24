class UserMailer < ActionMailer::Base
  default :from => "test@babyfolio.com"

  def confirmation_email(user)
    @user = user
    
    @url = confirmation_confirm_email_url

    @url += '?token='+ @user.perishable_token
    mail(:to => user.email, :subject => "Confirmation email")
  end

  def forgot_password(user)
    @user = user

    @url = edit_forgot_password_url
    @url += "?token=" + @user.perishable_token

    mail(:to => @user.email, :subject => "Forgot password")
  end

  def invite_user(relation, from, message = nil)
    @user = relation.user
    @from = from
    @relation = relation
    @message = message
    @url = confirmation_accept_invitation_url
    @url += "?token=" + relation.token
    mail(:to => @user.email, :subject => "Join family at Babyfolio")
  end

end
