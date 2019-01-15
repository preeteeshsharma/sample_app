ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
 include ApplicationHelper
  # Add more helper methods to be used by all tests here...
  
  # Returns true if a test user is logged in.
  #Inside controller tests, we can manipulate the session method directly, assigning user.id to the :user_id key 
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

#Inside integration tests, we can’t manipulate session directly, but we can post to the sessions path
class ActionDispatch::IntegrationTest

  # Log in as a particular user.
  #because it’s located inside the ActionDispatch::IntegrationTest class, 
  #this is the version of log_in_as that will be called inside integration tests
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
