require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  def setup

    login_user

  end

  test "get youtube video" do

    get :video

    
  end


end
