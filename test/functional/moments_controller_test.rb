require 'test_helper'

class MomentsControllerTest < ActionController::TestCase
  
  def setup
    
    login_user        

    @main_moment_tags = MomentTag.where(:moment_tag_id => nil)

  end

  test "should get index" do

    get :index
    
  end

  test "should post create" do
    
    assert_difference("Moment.count") do
      assert_difference("MomentTagsMoments.count", 2) do
        post :create, :moment => {:title => "Testing title"}, :cid => 3, :operation_type => "tag_it", :moment_tag_ids => [@main_moment_tags[0].id, @main_moment_tags[1].id]

        
        assert_response :redirect
      end
    end
    
  end  

end
