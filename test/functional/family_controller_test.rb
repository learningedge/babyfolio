require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase

  def setup
    
    login_user
    
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

    assert_difference("User.count", 3) do
      assert_difference("Relation.count", 3) do
          
        post :create_friend_relations, :friends => {
         "0" => { :email => 'raf.walczak@gmail.com', :member_type => 'cousin'},
         "2" => { :email => 'augustyn@codephonic.com', :member_type => 'grandmother' },
         "1" => { :email => 'jarek@codephonic.com', :member_type => 'grandfuther' }
        }
        assert_response :redirect
      end
    end

    assert_no_difference("User.count") do
      assert_no_difference("Relation.count") do
        post :create_friend_relations, :friends => {
          "0" => { :email => 'raf.walczak@gmail.com', :member_type => 'cousin'}
        }

        assert_response :success
      end
    end

    assert_no_difference("User.count") do
      assert_no_difference("Relation.count") do
        post :create_friend_relations, :friends => {
          "0" => { :email => 'niepoprawnymail', :member_type => 'cousin'}
        }

        assert_response :success
      end
    end

    assert_difference("User.count") do
      assert_difference("Relation.count") do
        post :create_friend_relations, :friends => {
          "0" => { :email => 'rafcio@gmail.com', :member_type => 'cousin'}
        }

        assert_response :redirect
      end
    end
    
  end

end
