require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # Create a test user which will become invalid to test validation
  def setup
    @user = User.new(name: "Example User", email: "user@example.come",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name not blank" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "email not blank" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "password not blank" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end
  
  test "acceptable name length" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "acceptable email length" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "acceptable password length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "accept valid email format" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "reject invalid email format" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email is unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts destroyed when user destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    michael = users(:michael)
    indiana  = users(:indiana)
    assert_not michael.following?(indiana)
    michael.follow(indiana)
    assert michael.following?(indiana)
    assert indiana.followers.include?(michael)
    michael.unfollow(indiana)
    assert_not michael.following?(indiana)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    indiana  = users(:indiana)
    solo    = users(:solo)
    # Posts from followed user
    solo.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    indiana.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
