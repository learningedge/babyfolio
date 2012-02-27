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

        post :create_friend_relations, :friends => {"3" => { :email => 'raf.walczak@gmail.com', :member_type => 'grandmother'}}

#        pp flash[:notice]

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

  test "post empty form" do
    post :create_friend_relations, :friends => {
          "0" => { :email => '', :member_type => 'cousin'},
          "1" => { :email => '', :member_type => 'grandmother'}
        }
    assert_response :success   
  end

# testing second form

  test "post empty second form" do
    
    assert_no_difference("User.count") do
      assert_no_difference("Relation.count") do
        post :create_friends, :emails => '', :message => 'Some message to users'
        assert_response :success
        
        post :create_friends, :emails => ',,,', :message => 'Some message to users'
        assert_response :success
        
      end
    end

  end

  test "post correct email" do
    assert_difference("User.count") do
      assert_difference("Relation.count") do
        
        post :create_friends, :emails => 'rafal@gmail.com', :message => 'Some message to users'
        assert_response :redirect

        post :create_friends, :emails => '   rafal@gmail.com,   , , ', :message => 'Some message to users'
        assert_response :success

        post :create_friends, :emails => ',,,rafal@gmail.com,,', :message => 'Some message to users'
        assert_response :success
        
      end
    end
  end

  test "post 3 emails" do

    assert_difference("User.count", 3) do
      assert_difference("Relation.count", 3) do
        post :create_friends, :emails => 'one@gmail.com,two@gmail.com,   three@gmail.com', :message => 'Some message to users'
        assert_response :redirect
        
      end
    end

  end

  test "post 2 emails with one in db" do

    assert_no_difference("User.count") do
      assert_no_difference("Relation.count") do
        post :create_friends, :emails => 'one@gmail.com,john@smith.com', :message => 'Some message to users'
        assert_response :success
      end
    end
    
  end

  test "get relations" do
    post :create_friends, :emails => 'one@gmail.com,two@gmail.com,   three@gmail.com', :message => 'Some message to users'
    get :relations
    assert_response :success
  end

  test "update relations" do
    post :create_friends, :emails => 'one@gmail.com,two@gmail.com,   three@gmail.com', :message => 'Some message to users'
    get :relations

    assert_no_difference("Relation.count") do
      post :create_relations, :relations => {
        "0" => {:display_name => 'one', :member_type => 'grandmother', :token => flash[:tokens][0] },
        "1" => {:display_name => 'two', :member_type => 'uncle', :token => flash[:tokens][1] },
        "2" => {:display_name => 'three', :member_type => 'godmother', :token => flash[:tokens][2]}
      }

      assert_not_nil flash[:tokens]

      relation = Relation.where(['display_name = ?', 'one']).first
      assert_not_nil relation
      assert_equal relation.member_type, 'grandmother', 'SHOULD BE GRANDMOTHER'
      assert_equal relation.user.email, 'one@gmail.com', 'SHOULD BE one@gmail.com'

      relation = Relation.where(['display_name = ?', 'two']).first
      assert_not_nil relation
      assert_equal relation.member_type, 'uncle', 'SHOULD BE UNCLE'
      assert_equal relation.user.email, "two@gmail.com", 'SHOULD BE two@gmail.com'

      relation = Relation.where(['display_name = ?', 'three']).first
      assert_not_nil relation
      assert_equal relation.member_type, 'godmother', 'SHOULD BE GODMOTHER'
      assert_equal relation.user.email, "three@gmail.com", "SHOULD BE three@gmail.com"

      

      assert_response :redirect
    end

  end

  test "get relations tokens" do
    post :create_friends, :emails => 'one@gmail.com,two@gmail.com,   three@gmail.com', :message => 'Some message to users'
    get :relations
    assert_not_nil flash[:tokens]

    get :relations
    assert_not_nil flash[:tokens]

    get :relations
    get :relations
    assert_not_nil flash[:tokens]
    
  end

  test "get family relations info" do
    post :create_friend_relations, :friends => {
          "0" => { :email => 'one@gmail.com', :member_type => 'cousin'},
          "1" => { :email => 'two@gmail.com', :member_type => 'grandmother'},
          "2" => { :email => 'three@gmail.com', :member_type => 'sister'},
          "3" => { :email => 'four@gmail.com', :member_type => 'grandmother'}
        }

    @relations = Relation.where(['member_type != "sister"']).all

    @relations.each do |relation|
      relation.update_attribute(:accepted, true)
    end

    get :family_relations_info
      pp assigns(:parents)
      pp assigns(:rest)
      assert_equal assigns(:parents).length, 1, 'ONLY ONE PARENT'
      assert_equal assigns(:rest).length, 4, 'FOUR FRIENDS'
    assert_response :success
  end

end
