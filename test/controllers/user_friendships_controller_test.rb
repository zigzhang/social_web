require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  
  context "#index" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :index
        assert_response :redirect
        assert_redirected_to new_user_session_path
      end
    end
    
    context "when logged in" do
      setup do
        @friendship1 = create(:pending_user_friendship, user: users(:zigzhang), friend: create(:user, first_name: 'Pending', last_name: 'Friend'))
        @friendship2 = create(:accepted_user_friendship, user: users(:zigzhang), friend: create(:user, first_name: 'Active', last_name: 'Friend'))
        
        sign_in users(:zigzhang)
        get :index
      end
      
      should "get the index page without error" do
        assert_response :success
      end
      
      should "assign user_friendship" do
        assert assigns(:user_friendships)
      end
      
      should "display friend's name" do
        assert_match /Pending/, response.body
        assert_match /Active/, response.body
      end
      
    end
  end
  
  context "#new" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to new_user_session_path
      end
    end
    
    context "when logged in" do
      setup do
        sign_in users(:zigzhang)
      end
      
      should "get new and return success" do
        get :new
        assert_response :success
      end
      
      should "should set a flash error if the friend_id is missing" do
        get :new, {}
        assert_equal "Friend required", flash[:error]
      end
      
      should "display the friend's name" do
        get :new, friend_id: users(:coco)
        assert_match /#{users(:coco).profile_name}/, response.body
      end
      
      should "assign a new user friendship" do
        get :new, friend_id: users(:coco)
        assert assigns(:user_friendship)
      end
      
      should "assign a new user friendship to the correct friend" do
        get :new, friend_id: users(:coco)
        assert_equal assigns(:user_friendship).friend, users(:coco)
      end
      
      should "assign a new user friendship to the currently logged in user" do
        get :new, friend_id: users(:coco)
        assert_equal assigns(:user_friendship).user, users(:zigzhang)
      end
      
      should "return a 404 status if no friend is found" do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end
      
      should "ask if you really want to friend the user" do
        get :new, friend_id: users(:coco)
        assert_match /Do you really want to friend #{users(:coco).profile_name}?/, response.body
      end
      
    end
    
  end
  
  context "#create" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to new_user_session_path
      end
    end
    
    context "when logged in" do
      setup do
        sign_in users(:zigzhang)
      end
      
      context "with no friend_id" do
        setup do
          post :create
        end
        
        should "set the flash error message" do
          assert !flash[:error].empty?
        end
        
        should "redirect to the root_path" do
          assert_redirected_to root_path
        end
      end
      
      context "successfully" do
        should "create two user friendship objects" do
          assert_difference 'UserFriendship.count', 2 do
            post :create, user_friendship: {friend_id: users(:coco).profile_name}
          end
        end
      end
      
      context "with a valid friend_id" do
        setup do
          post :create, user_friendship: { friend_id: users(:coco) }
        end
        
        should "assign a friend object" do
          assert assigns(:friend)
        end
        
        should "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal assigns(:user_friendship).friend, users(:coco)
          assert_equal assigns(:user_friendship).user, users(:zigzhang)
        end
        
        should "create a friendship" do 
          assert users(:zigzhang).pending_friends.include?(users(:coco))
        end
        
        should "redirect to profile page of the friend" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:coco))
        end
        
        should "set the flash success message" do
          assert flash[:success]
          assert_equal "Friend request sent", flash[:success]
        end
      end
    end
    
    context "#accept" do 
      context "when not logged in" do
        should "redirect to the login page" do
          put :accept, id: 1
          assert_response :redirect
          assert_redirected_to new_user_session_path
        end
      end
      
      context "when logged in" do
        setup do
          @friend = create(:user)
          @user_friendship = create(:pending_user_friendship, user: users(:zigzhang), friend: @friend)
          create(:pending_user_friendship, user: @friend, friend: users(:zigzhang))
          sign_in users(:zigzhang)
          put :accept, id: @user_friendship
          @user_friendship.reload
        end
        
        should "assign a user_friendship" do
          assert assigns(:user_friendship)
          assert_equal assigns(:user_friendship), @user_friendship
        end
        
        should "update the state accepted" do
          assert_equal 'accepted', @user_friendship.state
        end
        
        should "have a success message" do
          assert_equal "You are now friend with #{@user_friendship.friend.profile_name}", flash[:success]
        end
      end
    end
    
    context "#edit" do
      context "when not logged in" do
        should "redirect to the login page" do
          get :edit, id: 1
          assert_response :redirect
          assert_redirected_to new_user_session_path
        end
      end

      context "when logged in" do
        setup do
          @user_friendship = create(:pending_user_friendship, user: users(:zigzhang))
          sign_in users(:zigzhang)
          get :edit, id: @user_friendship
        end

        should "get edit and return success" do
          assert_response :success
        end
        
        should "assign to user_friendship" do
          assert assigns(:user_friendship)
        end
        
        should "assign to friend" do
          assert assigns(:friend)
        end
      end
    end
    
    context "#destroy" do 
      context "when not logged in" do
        should "redirect to the login page" do
          delete :destroy, id: 1
          assert_response :redirect
          assert_redirected_to new_user_session_path
        end
      end
      
      context "when logged in" do
        setup do
          @friend = create(:user)
          @user_friendship = create(:accepted_user_friendship, friend: @friend, user: users(:zigzhang))
          create(:accepted_user_friendship, friend: users(:zigzhang), user: @friend)
          sign_in users(:zigzhang)

        end
        
        should "delete user friendships" do
          assert_difference 'UserFriendship.count', -2 do
            delete :destroy, id: @user_friendship
          end
        end
        
        should "set the flash" do
          delete :destroy, id: @user_friendship
          assert_equal "Friendship destroyed", flash[:success]
        end
      end
    end
    
  end
  
end
