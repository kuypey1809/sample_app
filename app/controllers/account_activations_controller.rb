class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user.present?
      check_link user
    else
      flash[:danger] = t "layouts.flash.notfound"
      redirect_to root_path
    end
  end

  private

  def check_link user
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "layouts.flash.activated"
      redirect_to user
    else
      flash[:danger] = t "layouts.flash.invalid_link"
      redirect_to root_path
    end
  end
end
