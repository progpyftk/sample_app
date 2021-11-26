class SessionsController < ApplicationController
  def new; end

  def create
    provided_email = params[:teste_session][:email].downcase
    provided_password = params[:teste_session][:password]
    user = User.find_by(email: provided_email)
    if user && user.authenticate(provided_password)
      log_in user
      redirect_to user_url(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
