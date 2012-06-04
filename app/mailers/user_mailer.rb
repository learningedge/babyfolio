class UserMailer < ActionMailer::Base
  default :from => "test@babyfolio.qa.codephonic.com"

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

  def email_new_moment user, moment
    unless moment.visibility == Moment::VISIBILITY["Me only"]
      @user = user
      @moment = moment
      logger.info("Zobaczmy objekt child: #{@moment.child.inspect}")
      logger.info("Zobaczmy objekt user: #{@user.inspect}")
      friends = (@moment.child.family.users - [@user]).collect {|friend| friend.email}
      mail(:to => friends, :subcject => "Email to Village" )
    end
  end

end
