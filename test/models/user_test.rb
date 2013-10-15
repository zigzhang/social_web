require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
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
  
end
