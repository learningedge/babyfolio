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

  def invite_user relation, family
    @user = relation.user
    @inviter = relation.inviter
    @family = family
    @url = confirmation_accept_invitation_url
    @url += "?token=" + relation.token
    mail(:to => @user.email, :subject => "You've been invited to join BabyFolio!")
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
    mail(:to => @user.email, :subject => "Welcome to BabyFolio & #{@child.first_name}'s #{Question::CATS[@question.category] } Development: #{@milestone.get_title}")
  end

  def step_2_pending user
    @user = user
    mail(:to => @user.email, :subject => "Welcome to BabyFolio")
  end

  def step_3_pending user, child, milestone
    @user = user
    @child = child
    @milestone = milestone
    mail(:to => @user.email, :subject => "Welcome to BabyFolio")
  end

  def newsletter user, child, question_with_milestone, milestone_one, milestone_two
    @user = user
    @child = child
    @question = question_with_milestone
    @milestone = @question.milestone
    @milestone_next_1 = milestone_one
    @milestone_next_2 = milestone_two
    mail(:to => @user.email, :subject => "#{@child.first_name}'s #{Question::CATS[@question.category]} Development")
  end

  def inactive user, child
    @user = user
    @child = child
    mail(:to => @user.email, :subject => "How's #{@child.first_name}?")
  end

  def child_entered_learning_window user, child, milestone
    @user = user
    @child = child
    @milestone = milestone
    mail(:to => @user.email, :subject => "#{@child.first_name} just #{@milestone.get_title}.")
  end

  def invitation_accepted relation
    @user = relation.user
    @family = relation.child.family
    @inviter = relation.inviter
    @child = relation.child
    mail(:to => @user.email, :subject => "#{@user.get_user_name} has joined #{@child.first_name}'s BabyFolio!")
  end

  def timeline_comment child, comment_author, user
    @commenter = comment_author
    @child = child
    @user = user
    mail(:to => @user.email, :subject => "#{ @commenter.get_user_name } commented on #{@child.first_name}'s timeline.")
  end

  def account_deactivation data
    @data = data

    mail(:to => @data[:user_email], :subject => "Account Deactivation Confirmed")
  end

  def account_deactivation_survey data    
    @data = data
    
    mail(:to => ENV['CONTACT_EMAIL'] || "tickets@baby1.uservoice.com", :subject => "User Deactivate Account Survey")
  end

  
  
end
