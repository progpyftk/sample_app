module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    if user_id
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.encrypted[:user_id]
      user = User.find_by(id: cookies[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # checks if a user is logged in
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
