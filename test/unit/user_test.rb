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
    User.stubs(:with_actions).returns([@user_one, @user_two])

    @user_one.stubs(:send_step_3_email).returns(nil)
    @user_two.stubs(:send_step_3_email).returns(nil)

    @user_one.expects(:send_step_3_email)
    @user_two.expects(:send_step_3_email)

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


end
