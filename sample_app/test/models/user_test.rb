require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # Create a test user which will become invalid to test validation
  def setup
    @user = User.new(name: "Example User", email: "user@example.come")
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
  
  test "acceptable name length" do
    @user.name = "a" *51
    assert_not @user.valid?
  end
  
  test "acceptable email length" do
    @user.email = "a" * 256
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
end
