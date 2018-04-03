class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    redirect_to login_url, flash: {danger: t("alert.please_login")} unless logged_in?
  end
end


