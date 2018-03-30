class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, flash: {info: t("info.email_sent_with_password_reset")}
    else
      flash.now[:danger] = t "danger.email_not_found"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("alert.can_not_empty")
      render :edit
    elsif @user.update_attributes user_params
      login @user
      flash[:success] = t "success.password_has_been_reset"
      redirect_to @user
    else
      flash.now[:alert] = t "alert.fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]

    redirect_to root_url, flash: {danger: t("danger.email_not_found")} unless @user
  end

  def valid_user
    redirect_to root_url, flash: {danger: t("danger.invalid_user")}\
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "danger.password_reset_has_expired"
      redirect_to new_password_reset_url
    end
  end
end
