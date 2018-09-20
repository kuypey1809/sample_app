class SessionsController < ApplicationController
  def new
    return unless logged_in?
    flash[:info] = t "layouts.flash.logged"
    redirect_to current_user
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      check_activation user
    else
      flash.now[:danger] = t "layouts.flash.danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
