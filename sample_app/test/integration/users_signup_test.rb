require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user1 = users(:michael)
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                              email: "user@invalid",
                              password: "short",
                              password_confirmation: "longer" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end
  
  test "vadid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "goodpass",
                                         password_confirmation: "goodpass" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    
    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  
  test "cannot signup when already logged in" do
    get signup_path
    assert_template 'users/new'
    get root_path
    log_in_as(@user1)
    get signup_path
    assert_redirected_to root_url
  end
end
