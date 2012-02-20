require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase

  def setup
    
    login_user
    @one = families(:one)

  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
#    post :create
#    assert_response :success
  end


  test "should get add friends" do
    get :add_friends
    assert_response :success
  end

  test "should get create friend relations" do

    assert_difference("User.count") do
      assert_difference("Relation.count") do

        post :create_friend_relations, :friends => { "0" => {:email => 'augustyn@codephonic.com', :relation => 'grandmother' },
                                                     "1" => {:email => 'raf.walczak@gmail.com', :relation => 'cousin' },
                                                     "2" => {:email => 'jarek@codephonic.com', :relation => 'grandfuther'}
                                                   }
        
      end
    end
    
  end

end
