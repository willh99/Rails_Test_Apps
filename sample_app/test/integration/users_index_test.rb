require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:indiana)
  end
  
  test "index including pagination and admin destroy links" do
    # Login as an admin user and check for pagination tags
    log_in_as(@admin)
    get users_path
    assert_template 'users/index', count: 2
    assert_select 'div.pagination'
    
    # Obtain the first pagination page and check that the links are correct.
    # Make sure that the admin himself doesn't have a delete tag
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    
    # Delete a user and assert that the number of users decreased by 1
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non_admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
