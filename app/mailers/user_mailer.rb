class UserMailer < ActionMailer::Base
  default :from => ENV['EMAIL_FROM'] || "test@babyfolio.qa.codephonic.com"  

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
  
  def send_contact msg
     @msg = msg
     mail(:to => ENV['CONTACT_EMAIL'] || "tickets@baby1.uservoice.com", :subject => "New Contact Us Submission")
  end

  def registration_completed user, child, question
    @user = user
    @child = child
    @question = question
    @milestone = question.milestone
    mail(:to => @user.email, :subject => "Welcome to BabyFolio! & #{@child.first_name}'s #{Question::CATS[@question.category] } Development: #{@milestone.get_title}")
  end

  def step_2_pending user
    @user = user
    mail(:to => @user.email, :subject => "Welcome to BabyFolio!")
  end

  def step_3_pending user, child, milestone
    @user = user
    @child = child
    @milestone = milestone
    mail(:to => @user.email, :subject => "Welcome to BabyFolio!")
  end

end
