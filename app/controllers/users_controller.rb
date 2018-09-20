class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, only: [:show, :destroy]

  def index
    @users = User.activated.paginate(page: params[:page])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "layouts.flash.check_mail"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "layouts.flash.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "layouts.flash.deleted"
    else
      flash[:danger] = t "layouts.flash.cant_delete"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "layouts.flash.log_in"
    redirect_to login_path
  end

  def correct_user
    load_user
    return if @user == current_user
    redirect_to root_path
    flash[:danger] = t "layouts.flash.cant_edit"
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present? && @user.activated?
    flash[:danger] = t "layouts.flash.notfound"
    redirect_to root_path
  end
end
