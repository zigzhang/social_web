require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)
  
  test "a user should have a unique mail" do
    user = User.new
    user.email = users(:zigzhang).email
    assert !user.save
    assert !user.errors[:email].empty?
  end
  
# Test on profile_name
  test "a user should enter a profile name" do
    user = User.new
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end
  
  test "a user should have a unique profile_name" do
    user = User.new
    user.profile_name = users(:zigzhang).profile_name
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end
  
  test "a profile name should have a correct format" do
    user = User.new
    user.profile_name = "Profile name with spaces"
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end
  
  test "a user can have a correctly formatted profile name" do
    user = User.new(email: 'corentin@boutwik.com')
    user.password = user.password_confirmation = 'password'
  
    user.profile_name = 'zigzhang1'
    assert user.save
    assert user.valid?
  end
  
  test "that no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:zigzhang).friends
    end
  end
  
  test "that calling to_param on a user returns the profile_name" do
    assert_equal 'zigzhang', users(:zigzhang).to_param
  end
  
end
