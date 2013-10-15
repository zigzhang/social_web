require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "that a post has a user id" do
    post = Post.new
    assert !post.save
    assert !post.errors[:user_id].empty?
  end
  
end
