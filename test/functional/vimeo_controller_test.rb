require 'test_helper'

class VimeoControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get vimeo_ajax" do
    get :vimeo_ajax
    assert_response :success
  end

end
