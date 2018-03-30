class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]

    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      login user
      redirect_to user, flash: {success: t("success.account_activated")}
    else
      redirect_to root_url, flash: {danger: t("danger.invalid_activation_link")}
    end
  end
end
