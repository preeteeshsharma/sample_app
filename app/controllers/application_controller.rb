class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
   include SessionsHelper
   private

   # Confirms a logged-in user.
   	def logged_in_user
      unless logged_in?
      	#stores the current url that the user entered in sessions[:forwarding_url]
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
