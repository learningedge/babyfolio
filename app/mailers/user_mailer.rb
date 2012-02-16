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

end
