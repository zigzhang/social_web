require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  
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
          assert users(:zigzhang).friends.include?(users(:coco))
        end
        
        should "redirect to profile page of the friend" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:coco))
        end
        
        should "set the flash success message" do
          assert flash[:success]
          assert_equal "You are now friend with #{users(:coco).profile_name}", flash[:success]
        end
      end
      
    end
    
  end
  
end
