class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t "layouts.flash.notfound"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "layouts.flash.success"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
