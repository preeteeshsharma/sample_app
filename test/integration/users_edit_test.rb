require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  #for all tests we take the example user in fixtures.
  def setup
    @user = users(:example)
  end

  test "unsuccessful edit" do
  	#we log_in_as(@user) which is the way to log in in tests,see test_helper.rb
  	# we have done so because the user needs to log in before accessing the update page
  	log_in_as(@user)
  	#first get the user edit path
    get edit_user_path(@user)
    #edit trmplate is rendered after this
    assert_template 'users/edit'
    #patch request(for updating the user), invalid params hash
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
  	#log_in_as(@user)
    #get edit_user_path(@user)
    #assert_template 'users/edit'
    # if the user tries to get their edit path before being logged in
    #then he should be redirected to his edit page after logging in
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
