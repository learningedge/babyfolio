require 'test_helper'
require 'net/http'

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

  test 'step 2 welcome email only after 30 minutes' do    
    @user_one.send_step_2_email
    assert_equal 1, @user_one.user_emails.length

    @user_two.send_step_2_email
#    assert_equal 0, @user_one.user_emails.length

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
    # @user_one.expects(:send_step_3_email2).at_least(3)
    # @user_two.expects(:send_step_3_email2).at_least(3)

#    User.stubs(:with_actions).returns([@user_one, @user_two])

    User.send_step_3_pending_emails

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

    # User one unsubscribes

    @user_one.user_option.update_attribute(:subscribed, false)

    users = User.with_actions 'child_added', 'initial_questionnaire_completed',  (DateTime.now - 3.days)
    assert_equal 1, users.count
    assert users.include?(@user_three)
  end

  test 'resend_registration_completed - all correct' do
    @user_one.update_attribute(:last_login_at, DateTime.now - 8.days - 1.minute)

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
  

end
