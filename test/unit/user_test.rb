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
    assert_equal 0, @user_one.user_emails.length

  end

  test 'send step 3 pending email for user after 30 minutes of inactivity' do
#    @user_three.send_step_3_email
#    assert_equal 1, @user_three.user_emails
  end


end
