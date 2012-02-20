require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user_one = users(:one)
    @user_two = users(:two)
    @user_three = users(:three)

    login_user
  end

  test "user has family" do

    assert @user_one.is_parent?, 'USER HAS FAMILY'
    assert !@user_two.is_parent?, 'USER HAS NOT FAMILY'
    assert !@user_three.is_parent?, 'USER IS ONLY FRIEND OF FAMILY'
    
  end

  test "set family session" do

    assert @user_one.main_family, 'USER IS PARENT'
    assert !@user_two.main_family, 'USER DOES NOT HAVE FAMILY'
    assert @user_three.main_family, 'USER HAS FAMILY BUT HE IS ONLY COUSIN'

  end
end
