require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @user2 = users(:indiana)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do 
    log_in_as(@user2)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong user" do 
    log_in_as(@user2)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user2)
    assert_not @user2.admin?
    patch user_path(@user2), params: { 
                               user: { id: @user2.id,
                                       password: 'password',
                                       password_confirmation: 'password',
                                       admin: true } }
    assert_not @user2.reload.admin?
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
    assert_not flash.empty?
    log_in_as(@user)
    assert_redirected_to users_path
  end
  
  test "redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  test "redirect distroy when logged in as non admin" do
    log_in_as(@user2)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  test "redirect not activated user page to home" do 
    @user.update_attribute(:activated, false)
    get user_path(@user)
    assert_redirected_to root_url
    @user.update_attribute(:activated, true)
    get user_path(@user)
    assert_select "h1", @user.name
  end
  
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
    log_in_as(@user)
    get following_user_path(@user)
    assert_template 'users/show_follow'
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
    log_in_as(@user)
    get followers_user_path(@user)
    assert_template 'users/show_follow'
  end
end