require 'test_helper'

class ConfirmationControllerTest < ActionController::TestCase

  def setup
    
    login_user
  end

  test "should get index" do
    get :index

    assert_not_nil assigns(:user), "CURRENT USER IS NIL"

    assert_response :success
  end
  
end
