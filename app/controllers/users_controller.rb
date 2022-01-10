class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy] 
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to verify your account!'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    # @user = User.find(params[:id]) eliminamos pois o filtro before_action ja faz isso
  end

  def index
    @users = User.all
    @session_teste = session[:teste]
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Great! Changes were made!'
      redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email, :password, :password_confirmation)
  end

  # before filters
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in'
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
