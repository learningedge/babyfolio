class UserMailer < ActionMailer::Base
  default :from => "test@babyfolio.com"

  def confirmation_email(user)
    @user = user
    
    @url = confirmation_confirm_email_url

    @url += '?token='+ @user.perishable_token
    mail(:to => user.email, :subject => "Registratin email")
  end

end
