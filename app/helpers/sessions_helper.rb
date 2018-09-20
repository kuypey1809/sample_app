module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user? user
    user == current_user
  end

  def current_user
    case
    when session[:user_id]
      @current_user ||= User.find_by id: session[:user_id]
    when cookies.signed[:user_id]
      user = User.find_by id: cookies.signed[:user_id]
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def remember_or_forget user
    if params[:session][:remember_me] == Settings.session.remember_me
      remember user
    else
      forget user
    end
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def check_activation user
    if user.activated?
      log_in user
      remember_or_forget user
      redirect_back_or user
    else
      flash[:warning] = t "layouts.flash.not_activated"
      redirect_to root_path
    end
  end
end
