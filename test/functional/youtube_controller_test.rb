require 'test_helper'

class YoutubeControllerTest < ActionController::TestCase
  test "should index" do
    get :index
    assert_response :success
  end
end
