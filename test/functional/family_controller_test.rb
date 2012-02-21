require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase

  def setup
    
    login_user
    @family = families(:one)
    
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

  test "should add 3 users" do
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
  end

  test "the user is exist in db" do
    post :create_friend_relations, :friends => {"0" => { :email => 'raf.walczak@gmail.com', :member_type => 'cousin'}}

    assert_no_difference("User.count") do
      assert_no_difference("Relation.count") do
        post :create_friend_relations, :friends => {
          "0" => { :email => 'raf.walczak@gmail.com', :member_type => 'cousin'}
        }

        assert_response :success
      end
    end
  end

  test "should not add user to db and should send error" do
    assert_no_difference("User.count") do
      assert_no_difference("Relation.count") do
        post :create_friend_relations, :friends => {
          "0" => { :email => 'niepoprawnymail', :member_type => 'cousin'}
        }

        assert_response :success
      end
    end
  end

  test "check if blank emails are added" do
    assert_difference("User.count") do
      assert_difference("Relation.count") do
        post :create_friend_relations, :friends => {
          "0" => { :email => 'rafalek@gmail.com', :member_type => 'cousin'},
          "1" => { :email => '  ', :member_type => 'grandmother'}
        }
   
        assert_response :redirect
      end
    end
  end

  test "send 2 the same emails" do
    assert_no_difference("User.count") do
      assert_no_difference("Relation.count") do
        post :create_friend_relations, :friends => {
          "0" => { :email => 'next1@gmail.com', :member_type => 'cousin'},
          "1" => { :email => '  ', :member_type => 'grandmother'},
          "2" => { :email => 'next1@gmail.com', :member_type => 'uncle
            '}
        }

        assert_response :success
      end
    end
  end

  test "check if add correct relations" do
    post :create_friend_relations, :friends => {
          "0" => { :email => 'rafalek@gmail.com', :member_type => 'cousin'},
          "1" => { :email => '  ', :member_type => 'grandmother'}
        }

    user = User.where(["email = ?",'rafalek@gmail.com']).first
    
    assert_equal user.relations.first.member_type, 'cousin', 'CHECK IF THE MEMBER TYPA FIELD WAS ADDED'
    assert_equal user.families.first.name, @family.name, 'CHECK IF THE FAMILY RELATION WAS ADDED'
  end


  test "check existing email" do
    post :create_friend_relations, :friends => {
          "0" => { :email => 'john@smith.com', :member_type => 'cousin'},
          "1" => { :email => 'raf.walczak@gmail.com', :member_type => 'grandmother'}
        }
  end
  
end
