class UsersController < ApplicationController
  before_action :load_user, only: [:show]

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to @user,flash: {success: t("welcome2")}
    else
      flash[:danger] = t "alert.create_fail"
      render "new"
    end
  end

  private

  def load_user
    redirect_to "/", flash: {danger: t("alert.user_not_found")}\
    unless @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
