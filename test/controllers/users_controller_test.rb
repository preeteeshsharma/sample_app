require 'test_helper'
#put action-level tests of access control 
class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
    @other_user = users(:arora)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end
  #test for before action, edit method
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  #test for before action, update method
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  #for users not logged in and trying to access index page
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  #first, users who aren’t logged in should be redirected to the login page; 
  test "should redirect destroy when not logged in" do
    #no user is being deleted
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  #second, users who are logged in but who aren’t admins should be redirected to the Home page.
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
