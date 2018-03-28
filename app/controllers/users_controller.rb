class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :load_user, except: %i(new index create)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.per_page
  end

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new user_params

    if @user.save
      login @user
      redirect_to @user, flash: {success: t("welcome2")}
    else
      flash.now[:danger] = t "alert.create_fail"
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      redirect_to @user, flash: {success: t("alert.profile_updated") }
    else
      flash.now[:danger] = t "alert.update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_url, flash: {success: t("alert.user_deleted")}
    else
      flash.now[:danger] = t "alert.delete_fail"
      render :index
    end
  end

  private

  def load_user
    redirect_to "/", flash: {danger: t("alert.user_not_found")}\
    unless @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    redirect_to login_url, flash: {danger: t("alert.please_login")} unless logged_in?
  end

  def correct_user
    @user = User.find_by id: params[:id]

    redirect_to "/", flash: {danger: t("alert.access_denied")}\
    unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
