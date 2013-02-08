require 'test_helper'

class UserTest < ActiveSupport::TestCase  

  def setup
    @user_one = users(:one)
    @user_two = users(:two)
    @user_three = users(:three)
    @user_four = users(:four)

#    login_user
  end

  test 'should have options' do
    assert @user_one.user_option.present?
    assert @user_two.user_option.present?
    assert @user_three.user_option.present?
    assert @user_four.user_option.present?

  end


  test 'should load subscribed users only' do
    assert_equal 3, User.subscribed.count
  end  

  test 'send step 3 pending email for user after 30 minutes of inactivity' do
    user_action = user_actions(:five)

    # User action 'child_added' exists and is at least 30 minutes old
    assert_equal @user_three, user_action.user
    assert_equal 'child_added', user_action.title
    assert user_action.created_at + 30.minutes < DateTime.now

    # There are no emails sent with title 'child_added'
    assert_equal nil, UserEmail.find_by_user_id_and_title(@user_three, 'child_added')    

    # Emulate that there is a questions and the milestone
    Question.stubs(:find_by_category).returns(questions(:questions_226))

    assert @user_three.send_step_3_email

    user_email = UserEmail.find_by_user_id_and_title(@user_three, 'child_added')    
    assert user_email      

    Question.unstub(:find_by_category)
  end

  test 'send step 3 email - there was only 28 minutes of inactivity' do
    user_action = user_actions(:five)
    user_action.created_at = DateTime.now - 28.minutes
    user_action.save

    # User action 'child_added' exists and is less than 30 minutes old
    assert_equal @user_three, user_action.user
    assert_equal 'child_added', user_action.title
    assert user_action.created_at + 30.minutes > DateTime.now

    # There are no emails sent with title 'child_added'
    assert_equal nil, UserEmail.find_by_user_id_and_title(@user_three, 'child_added')    

    # Emulate that there is a questions and the milestone
    Question.stubs(:find_by_category).returns(questions(:questions_226))

    assert_equal false, @user_three.send_step_3_email

    user_email = UserEmail.find_by_user_id_and_title(@user_three, 'child_added')    
    assert_nil user_email      

    Question.unstub(:find_by_category)
  end


  test 'send step 3 email - an email was already sent' do
    user_action = user_actions(:five)

    # User action 'child_added' exists and is more than 30 minutes old
    assert_equal @user_three, user_action.user
    assert_equal 'child_added', user_action.title
    assert user_action.created_at + 30.minutes < DateTime.now

    # There are is an email already sent with title 'child_added'

    user_email = user_emails(:one)
    user_email.title = 'child_added'
    user_email.save

    assert_equal user_email, UserEmail.find_by_user_id_and_title(@user_three, 'child_added')    

    # Emulate that there is a questions and the milestone
    Question.stubs(:find_by_category).returns(questions(:questions_226))

    assert_equal false, @user_three.send_step_3_email

    Question.unstub(:find_by_category)

    user_email_2 = UserEmail.find_by_user_id_and_title(@user_three, 'child_added')    
    assert_equal user_email.count, user_email_2.count
  end


  test 'send_step_3_pending_emails - two users apply' do   
    @user_one.stubs(:send_step_3_email).returns(nil)
    @user_two.stubs(:send_step_3_email).returns(nil)

    # @user_one.expects(:send_step_3_email2).at_least(3)
    # @user_two.expects(:send_step_3_email2).at_least(3)

#    User.stubs(:with_actions).returns([@user_one, @user_two])

#    User.send_step_3_pending_emails

    User.unstub(:with_actions)
    @user_one.unstub(:send_step_3_email)
    @user_two.unstub(:send_step_3_email)
  end

  test 'with_actions function' do
    user_action_1 = user_actions(:six)
    user_action_1.user = @user_one
    user_action_1.title = 'child_added'
    user_action_1.save

    users = User.with_actions 'child_added', 'initial_questionnaire_completed', (DateTime.now - 3.days)
    assert_equal 2, users.count
    
    assert users.include?(@user_one)
    assert users.include?(@user_three)

    #user one added child later than 3 days ago
    user_action_1.created_at = DateTime.now - 4.days
    user_action_1.save
    users = User.with_actions 'child_added', 'initial_questionnaire_completed', (DateTime.now - 3.days)
    assert_equal 1, users.count

    # User one unsubscribes

    @user_one.user_option.update_attribute(:subscribed, false)


    users = User.with_actions 'child_added', 'initial_questionnaire_completed', (DateTime.now - 3.days)
    assert_equal 1, users.count
    assert users.include?(@user_three)
  end

  test 'resend_registration_completed - all correct' do
    @user_one.update_attribute(:last_login_at, DateTime.now - 8.days - 1.minute)
    @user_one.user_option.update_attribute(:subscribed, true)
    
    user_email = UserEmail.create(:title => 'initial_questionnaire_completed', :user => @user_one)
    assert_equal 1, user_email.count
    assert_equal @user_one, user_email.user
    assert_equal 2, @user_one.children.count
    
    @user_one.children.first.answers.create(:question_id => 964)

    counts = UserEmail.sum(:count)

#    User.unstub(:get_first_answer_for_one_of_the_categories)

    User.resend_registration_completed

    user_email.reload
    
    assert_equal 2, user_email.count
    assert_equal counts+1, UserEmail.sum(:count)

    User.resend_registration_completed

    user_email.reload
    assert_equal 2, user_email.count
  end

  test 'resend_registration_completed - logged in in the meantime' do
    @user_one.update_attribute(:last_login_at, DateTime.now - 6.days - 1.minute)

    @user_one.user_option.update_attribute(:subscribed, true)

    user_email = user_emails(:one)
    user_email.user = @user_one
    user_email.title = 'initial_questionnaire_completed'
    user_email.count = 0
    user_email.save

    assert_equal 1, user_email.count
    
    User.stubs(:get_first_answer_for_one_of_the_categories).returns(answers(:one))

    counts = UserEmail.sum(:count)

#    User.unstub(:get_first_answer_for_one_of_the_categories)

    User.resend_registration_completed

    user_email.reload
    assert_equal 1, user_email.count
    assert_equal counts, UserEmail.sum(:count)

  end  
  
  test 'reutrn users with account created no longer than 3 days ago without a child' do
    users = User.subscribed.with_actions('account_created', 'child_added', (DateTime.now - 3.days))
    assert_equal 2, users.length
    assert users.include?(@user_one)
    assert users.include?(@user_two)

    # user_one adds a child
    @user_one.user_actions.create(:title => 'child_added')
    users = User.subscribed.with_actions('account_created', 'child_added', (DateTime.now - 3.days))
    assert_equal 1, users.length
    assert !users.include?(@user_one), "shouldnt include user_one"
    assert users.include?(@user_two)

    #user_two created account 5 days ago
    user_action_2 = @user_two.user_actions.find_by_title('account_created')
    assert user_action_2
    user_action_2.created_at = DateTime.now - 5.days
    user_action_2.save
    users = User.subscribed.with_actions('account_created', 'child_added', (DateTime.now - 3.days))
    assert_equal 0, users.length
    assert !users.include?(@user_one), "shouldnt send email to @user_one"
    assert !users.include?(@user_two), "shouldnt send email to @user_two"

  end
  

  test 'send step 2 email only once' do
    assert @user_one.user_emails.empty?
       
    @user_one.send_step_2_email
    @user_one.reload
    assert_equal 1, @user_one.user_emails.length
    assert_equal 1, @user_one.user_emails.first.count
    
    @user_one.send_step_2_email
    @user_one.reload
    assert_equal 1, @user_one.user_emails.length
    assert_equal 1, @user_one.user_emails.first.count
  end

  test 'send step 2 email after 30 minutes of inactivity' do
    ua = @user_one.user_actions.find(user_actions(:one))

    #user emails empty before send check
    assert ua.title = 'account_created'
    assert ua.created_at + 30.minutes < DateTime.now
    assert @user_one.user_emails.empty?

    @user_one.send_step_2_email
    @user_one.reload
    assert_equal 1, @user_one.user_emails.length    

  end

  test 'dont send if account_created less then 30 minutes ago' do
    #user added account 10 minutesago
    ua = @user_one.user_actions.find(user_actions(:one))
    ua.created_at = DateTime.now - 10.minutes
    ua.save
    assert ua.created_at + 9.minutes < DateTime.now

    @user_one.send_step_2_email
    assert_equal 0, @user_one.user_emails.length   
  end

  test 'test with_newsletter_email_for_frequency should return users with emails sent later than frequency' do
    # => @user_one newsletter email last sent 9 days ago
    date = DateTime.now - 9.days
    email = @user_one.send_email!('newsletter')
    email.update_attributes({:updated_at => date})
    assert email.updated_at.to_datetime <=  DateTime.now - 7.days

    assert_equal 1, User.with_email_title_for_frequency("newsletter", 'weekly').count

    # => @user_two newsletter email last sent 6 days ago
    date = DateTime.now - 6.days
    email = @user_two.send_email!('newsletter')
    email.update_attributes({:updated_at => date})
    assert email.updated_at.to_datetime >=  DateTime.now - 7.days

    assert_equal 1, User.with_email_title_for_frequency("newsletter", 'weekly').count
    assert_equal 0, User.with_email_title_for_frequency("newsletter", 'monthly').count

    # =>  @user_two newsletter email last sent 40 days ago
    date = DateTime.now - 40.days
    email.update_attributes({:updated_at => date})

    assert_equal 1, User.with_email_title_for_frequency("newsletter", 'weekly').count
    assert_equal 1, User.with_email_title_for_frequency("newsletter", 'monthly').count
        
    # => @user_two frequency changed to weekly
    @user_two.user_option.update_attributes({:newsletter_frequency => 'weekly'})

    assert_equal 2, User.with_email_title_for_frequency("newsletter", 'weekly').count
    assert_equal 0, User.with_email_title_for_frequency("newsletter", 'monthly').count
  end

  test 'without_email' do
    # testing 3 subscribed users without 'newsletter' email
    assert_equal 3, User.without_email('newsletter').count
    assert_equal 2, User.without_email('Testing').count
  end

  test 'without_newsletter_email_for_frequency' do    
    assert_equal 0, User.without_newsletter_email_for_frequency('weekly').count

    # => setup @user_three for account created 9 days(has weekly frequency)
    action = @user_three.do_action!('account_created')
    action.update_attributes({:created_at => DateTime.now - 9.days})

    assert_equal 1, User.without_newsletter_email_for_frequency('weekly').count

    # => setup @user_three for account created 9 days but has monthly frequency
    action = @user_two.do_action!('account_created')
    action.update_attributes({:created_at => DateTime.now - 9.days})

    assert_equal 1, User.without_newsletter_email_for_frequency('weekly').count

    # => setup @user_three for account created 9 days but with weekly frequency
    @user_two.user_option.update_attributes({:newsletter_frequency => 'weekly'})

    assert_equal 2, User.without_newsletter_email_for_frequency('weekly').count

    # => setup @user_one for account created twa days ago with daily frequency
    @user_one.user_option.update_attributes({:newsletter_frequency => 'daily'})
    action = @user_one.do_action!('account_created')
    action.update_attributes({ :created_at => DateTime.now - 2.days  })
    assert_equal 1, User.without_newsletter_email_for_frequency('daily').count
    
  end

  test 'select_users_for_newsletter' do
    assert_equal 0, User.select_users_for_newsletter.count

    date = DateTime.now - 9.days
    email = @user_one.send_email!('newsletter', :updated_at => date)
    assert @user_one.user_option.newsletter_frequency == 'weekly', "should be weekly"
#    email.update_attributes({:updated_at => date})

    date = DateTime.now - 40.days
    email = @user_two.send_email!('newsletter',  :updated_at => date )    
    assert @user_two.user_option.newsletter_frequency == 'monthly', "should be monthly"
#    email.update_attributes({:updated_at => date})

    users = User.select_users_for_newsletter    
    assert_equal 2, users.count
    assert users.first.is_a?(User), "should be of User type"
    assert users.first.association('user_option').loaded? , "should eager load user options"

    #change @user_one to monthly subscription
    @user_one.user_option.update_attribute(:newsletter_frequency, 'monthly')
    users = User.select_users_for_newsletter
    assert_equal 1, users.count
  end

  test 'send_newsletter' do
    date = DateTime.now - 40.days
    action = @user_one.do_action!('account_created')
    action.update_attributes({:created_at => date})
    #email = @user_one.send_email!('newsletter', :updated_at => date)
    #email = @user_two.send_email!('newsletter',  :updated_at => date )

    @user_one.my_children.first.answers.create(:question_id => 964)
    @user_one.my_children.first.answers.create(:question_id => 776)
    
    assert_equal 2, @user_one.my_children.first.answers.count
    assert_equal 1, User.select_users_for_newsletter.count, 'should be one user'
    assert_equal 0, @user_one.user_emails.find_all_by_title("newsletter").count
    email = @user_one.user_emails.find_by_title('newsletter')
    assert_nil(email)
    
    User.send_newsletters

    email = @user_one.user_emails.find_by_title('newsletter')
    assert_not_nil email.child_id
    assert_equal 1, @user_one.user_emails.find_all_by_title("newsletter").count

    assert_equal 0, User.select_users_for_newsletter.count    
    assert_equal 's', email.description

    email.update_attributes(:updated_at => date)
    assert_equal 1, User.select_users_for_newsletter.count

    User.send_newsletters

    email.reload
    assert email.updated_at >= DateTime.now - 1.minutes
          
  end

  test 'select_inactive_users' do
    assert_equal 0, User.select_inactive_users.count

    #  user one inactive for 16 days (no inactive email) - send first email
    @user_one.update_column(:last_request_at, DateTime.now - 16.days)
    
    users = User.select_inactive_users
    assert_equal 1, users.count
    assert_equal @user_one, users[0]

    #  user two inactive for 16 days (no inactive email) - send first email
    @user_two.update_column(:last_request_at, DateTime.now - 16.days)
    users = User.select_inactive_users
    assert_equal 2, users.count

    #  user three inactive for 25 days - over 3 weeks (email sent 8.days.ago) - send reminder
    @user_three.update_column(:last_request_at, DateTime.now - 22.days)
    assert_equal 2, User.select_inactive_users.count

    email = @user_three.send_email!('inactive')
    email.update_attributes(:updated_at => DateTime.now - 7.days)
    assert_equal 3, User.select_inactive_users.count

    # user one was inactive in the past - last inactive email sent 4 weeks ago - np
    email = @user_one.send_email!('inactive')
    email.update_attributes(:updated_at => DateTime.now - 4.weeks)
    
    assert_equal 3, User.select_inactive_users.count

    # user 3 has been inactive for 1 month
    @user_three.update_column(:last_request_at, DateTime.now - 1.months)
    assert_equal 2, User.select_inactive_users.count

    # user 3 has been inactive for 1 week ( inactive email sent 7 days ago )
    @user_three.update_column(:last_request_at, DateTime.now - 1.weeks)
    assert_equal 2, User.select_inactive_users.count
        
  end

  test 'send_inactive' do    
    #  user one inactive for 16 days (no inactive email) - send first email    
    @user_one.update_column(:last_request_at, DateTime.now - 16.days)
    assert_equal 1, User.select_inactive_users.count

    User.send_inactive

    assert_equal 0, User.select_inactive_users.count
    email = @user_one.user_emails.find_by_title('inactive')
    assert email
    email_updated_at_1 = email.updated_at
    assert_equal 1, email.count
    assert email_updated_at_1 > DateTime.now - 1.minutes
    sleep(1)

    # 7 days after - send reminder
    @user_one.update_column(:last_request_at, @user_one.last_request_at - 7.days)
    email.update_column(:updated_at, email.updated_at - 7.days)
    assert_equal 1, User.select_inactive_users.count
    
    User.send_inactive

    email.reload
    email_updated_at_2 = email.updated_at
    assert email_updated_at_2 > DateTime.now - 1.minutes
    assert email_updated_at_2 > email_updated_at_1
    assert_equal 2, email.count
    assert_equal 0, User.select_inactive_users.count

    # after another week - dont send reminder anymore
    @user_one.update_column(:last_request_at, @user_one.last_request_at - 7.days)
    assert_equal 0, User.select_inactive_users.count
    User.send_inactive
    email.reload
    assert email.updated_at > DateTime.now - 1.minutes
    
    
  end

end
