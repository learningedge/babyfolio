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

  def invite_user(user, relation)
    @user = user
    @relation = relation #@user.relations.find(:family_id => family.id).display_name
    @url = confirmation_accept_invitation_url
    @url += "?token=" + @user.perishable_token
    mail(:to => @user.email, :subject => "Join family at Babyfolio")
  end

end
