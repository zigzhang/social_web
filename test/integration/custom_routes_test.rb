require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  
  test "that /feed route opens the posts#index" do
    get "/feed"
    assert_response :success
  end
  
  test "that signing_out redirects to root" do
    delete "/users/sign_out"
    assert_response :redirect
    assert_redirected_to '/'
  end
  
  test "thata profile page works" do
    get '/zigzhang'
    assert_response :success
  end
  
  
end
