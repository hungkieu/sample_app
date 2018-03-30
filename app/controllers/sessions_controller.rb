class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_to user, flash: {success: t("welcome2")}
      else
        redirect_to root_url, flash: {warning: t("warning.check_email")}
      end
    else
      flash.now[:danger] = t "alert.invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, flash: {success: t("alert.logout")}
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
end
