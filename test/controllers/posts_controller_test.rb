require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "new - should be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end
  
  test "new - should render the new page when logged in" do
    sign_in users(:zigzhang)
    get :new
    assert_response :success
  end
  
  test "create - should be redirected when not logged in" do
    post :create, post: {content: @post.content, title: @post.title}
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end

  test "create - should create post when logged in" do
    sign_in users(:zigzhang)
    assert_difference('Post.count') do
      post :create, post: { content: @post.content, title: @post.title }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "create - should create post for the current user when logged in" do
    sign_in users(:zigzhang)
    assert_difference('Post.count') do
      post :create, post: { content: @post.content, title: @post.title, user_id: users(:coco).id }
    end
    
    assert_redirected_to post_path(assigns(:post))
    assert_equal assigns(:post).user_id, users(:zigzhang).id
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "edit - should be redirected when not logged in" do
    get :edit, id: @post
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end
  
  test "edit - should render edit when logged in" do
    sign_in users(:zigzhang)
    get :edit, id: @post
    assert_response :success
  end

  test "update - should be redirected when not logged in" do
    patch :update, id: @post, post: { content: @post.content, title: @post.title }
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end
  
  test "update - should update when logged in" do
    sign_in users(:zigzhang)
    patch :update, id: @post, post: { content: @post.content, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end
  
  test "update - should update post for the current user when logged in" do
    sign_in users(:zigzhang)
    patch :update, id: @post, post: { content: @post.content, title: @post.title, user_id: users(:coco).id }
    assert_redirected_to post_path(assigns(:post))
    assert_equal assigns(:post).user_id, users(:zigzhang).id
  end

  test "destroy - should be redirected when not logged in" do
    assert_difference('Post.count', 0) do
      delete :destroy, id: @post
    end

    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end
  
  test "destroy - should destroy when logged in" do
    sign_in users(:zigzhang)
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end
end
