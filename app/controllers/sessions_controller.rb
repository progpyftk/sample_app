class SessionsController < ApplicationController
  def new; end

  def create
    provided_email = params[:session][:email].downcase
    provided_password = params[:session][:password]
    user = User.find_by(email: provided_email)
    if user && user.authenticate(provided_password)
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
