class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :defined_user, only: [:show, :destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    if @user.present? && @user.activated?
      @microposts = @user.microposts.paginate page: params[:page]
    else
      flash[:danger] = t "layouts.flash.notfound"
      redirect_to root_path
    end
  end

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
    if @user.update_attributes user_params
      flash[:success] = t "layouts.flash.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.present?
      @user.destroy
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

  def correct_user
    defined_user
    if @user.present?
      return if current_user? @user
      flash[:danger] = t "layouts.flash.cant_edit"
      redirect_to @user
    else
      flash[:danger] = t "layouts.flash.notfound"
      redirect_to root_path
    end
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def defined_user
    @user = User.find_by id: params[:id]
  end
end
