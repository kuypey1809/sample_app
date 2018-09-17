class SessionsController < ApplicationController
  def new
    return unless logged_in?
    flash[:info] = t "layouts.flash.logged"
    redirect_to current_user
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t "layouts.flash.danger"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
