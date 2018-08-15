require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid user not committed" do
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
  
  test "vadid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "goodpass",
                                         password_confirmation: "goodpass" } }
    end
    follow_redirect!
    assert_template 'users/show'
  end
end
