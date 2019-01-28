class UsersController < ApplicationController
  #calls a particular method before an action takes place. 
  #has an optional only hash as it is applied to every controller method
  #acts oon a per action basis
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def index
     @users = User.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Send authentication email and redirect to root
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    #this is being defined before in the correct_user method
   # @user = User.find(params[:id])
  end

  def update
    #this is being defined before in the correct_user method
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters
    
    #moved to application controller
    #if a user is trying to access his edit page without being logged in 
    # Confirms a logged-in user.
    #def logged_in_user
    # unless logged_in?
    #    #stores the current url that the user entered in sessions[:forwarding_url]
    #    store_location
    #    flash[:danger] = "Please log in."
    #    redirect_to login_url
    #  end
    #end
    #if another user is trying to access someone's edit page 
    
    # Confirms the correct user.
    def correct_user
      # @user is used in edit and update actions. So if current user is someone else
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end