require 'test_helper'

class AddAFriendTest < ActionDispatch::IntegrationTest
  def sign_in_as(user, password)
    post new_user_session_path, user: { email: user.email, password: password }
  end
  
  test "that adding a friend works" do
    sign_in_as users(:zigzhang), "testing"
    get "/user_friendships/new?friend_id=#{users(:coco).profile_name}"
    assert_response :success
    
    assert_difference 'UserFriendship.count' do
      post "/user_friendships", user_friendship: { friend_id: users(:coco).profile_name }
      assert_response :redirect
      assert_equal "You are now friend with #{users(:coco).profile_name}", flash[:success]
    end
    
  end
end
