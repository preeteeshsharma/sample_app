module SessionsHelper
	def log_in(user)
    	session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
	#def current_user
  # 	if session[:user_id]
  #    	@current_user ||= User.find_by(id: session[:user_id])
  #  	end
	#end

	def logged_in?
    	!current_user.nil?
  end  

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end	

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    #if session user id exists assign it to user id.
    #the meaning of an existing session id is that user hasn't closed the browser
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # else if a cookie exists, then assign it to the user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
