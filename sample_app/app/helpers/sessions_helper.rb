module SessionsHelper
    
    # Logs in the given user
    def log_in(user)
        session[:user_id] = user.id
    end
    
    # Returns the current user if on exists
    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end
    
    # Returns true if the user is logged in. Else false
    def logged_in?
        !current_user.nil?
    end
    
    # Logs out the current user
    def log_out
        # Same as session[:user_id] = nil
        session.delete(:user_id)
        @current_user = nil
    end
end
