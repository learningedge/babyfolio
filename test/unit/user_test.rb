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

    assert @user_one.has_family?, 'USER HAS FAMILY'
    assert !@user_two.has_family?, 'USER HAS NOT FAMILY'
    assert !@user_three.has_family?, 'USER IS ONLY FRIEND OF FAMILY'
    
  end
end
