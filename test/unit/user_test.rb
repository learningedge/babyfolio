require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user_one = users(:one)
    @user_two = users(:two)
    @user_three = users(:three)
  end

  test "user has family" do

    assert @user_one.is_parent?, 'USER HAS FAMILY'
    assert !@user_two.is_parent?, 'USER HAS NOT FAMILY'
    assert !@user_three.is_parent?, 'USER IS ONLY FRIEND OF FAMILY'
    
  end
end
