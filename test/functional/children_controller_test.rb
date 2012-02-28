require 'test_helper'

class ChildrenControllerTest < ActionController::TestCase

  def setup
    
    login_user
    @family = families(:one)

  end

  test "should get index" do
    get :show

    child = children(:one)

    assert_equal assigns(:child),  child

    get :show

    assert_equal assigns()

    assert_response :success
  end

  test "should get edit" do
    get :edit

    assert_response :success
  end

  test "should get update" do
    post :update

    assert_response :redirect
  end
end
