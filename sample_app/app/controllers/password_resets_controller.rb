class PasswordResetsController < ApplicationController
  before_action :get_user,    only: [:edit, :update]
  before_action :valid_user,  only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      if !@user.activated?
        message = "Please activate your account before attempting a password "
        message += "reset.  An activation email should have been sent to "
        message += @user.email
        flash[:danger] = message
        redirect_to root_url
      else
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info] = "A link to reset your password was sent to #{@user.email}"
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "cannot be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # Before Filters #
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms authentic user for password reset
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Reset token has expired"
        redirect_to new_password_reset_url
      end
    end
end
