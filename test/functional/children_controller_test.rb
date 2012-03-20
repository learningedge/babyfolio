require 'test_helper'

class ChildrenControllerTest < ActionController::TestCase

  def setup
    
    login_user
    @family = families(:one)
    @child_one = children(:one)

  end

  test "should get show" do
    get :show

    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @child_one.id

    assert_response :success
  end

  test "should get update" do    

    assert_difference('Attachment.count') do
      assert_difference('Media.count') do
        request.env["HTTP_REFERER"] = "http://onet.pl"

        # there must be real path to the image
        post :update, :id => @child_one.id, :flickr_photos => ['http://farm8.static.flickr.com/7809/6832651028_40c953f247_b.jpg'], :flickr_pids => ["1234567890"]
        
       child = Child.find(@child_one.id)
        
       assert_equal "1234567890" ,child.media.media_id
        
      end      
    end

    assert_no_difference('Attachment.count') do
      assert_no_difference('Media.count') do

        post :update, :id => @child_one.id, :flickr_photos => ['http://farm8.static.flickr.com/7809/6832651028_40c953f247_b.jpg'], :flickr_pids => ["1234567890"]
        
      end
    end

    assert_no_difference('Attachment.count') do
      assert_difference('Media.count') do

        # there must be real path to the image
        post :update, :id => @child_one.id, :facebook_photos => ['http://farm8.static.flickr.com/7809/6832651028_40c953f247_b.jpg'], :facebook_pids => ["0987654321"]
        
       child = Child.find(@child_one.id)

       assert_equal "0987654321" ,child.media.media_id
        
      end      
    end

    assert_response :redirect
  end
end
