require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  # Using gem shoulda
  should belong_to(:user)
  should belong_to(:friend)
  
  test "that creating a friendship works without raising an exception" do
    assert_nothing_raised do
      UserFriendship.create user: users(:zigzhang), friend: users(:coco)
    end
  end
  
  test "that creating friendships on a user works" do
    users(:zigzhang).friends << users(:keke)
    users(:zigzhang).friends.reload
    assert users(:zigzhang).friends.include?(users(:keke))
  end
  
  test "that creating a friendship based on user id and friend id works" do
    UserFriendship.create user_id: users(:zigzhang).id, friend_id: users(:keke).id
    assert users(:zigzhang).friends.include?(users(:keke))
  end
  
end
