require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    
  end

  test 'change family' do

    login_user

    @family = families(:two)
    
    post :change_family, :id => @family.id
    
    assert_equal session[:current_family], @family.id.to_s, 'CHECK IF CURRENT FAMILY SESSION IS CORRECT'

    post :change_family, :id => 1

    assert_not_equal session[:current_family], @family.id.to_s, 'CHECK IF CURRENT FAMILY SESSION IS NOT CORRECT'

  end
  
end
