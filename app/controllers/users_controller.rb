class UsersController < ApplicationController
  before_action :set_user, only: %i[show followers following]

  # GET /users
  def index
    @users = User.all.order(followers_count: :desc).limit(100)
  end

  # GET /users/1
  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  # DELETE /users/1
  def destroy
    current_user.destroy
    redirect_to :root, notice: 'User was successfully destroyed.'
  end

  # GET /settings
  def settings; end

  def followers
    @followers = @user.followers
  end

  def following
    @following = @user.following
  end

  # GET /easter_egg
  def easter_egg
    current_user.roll_user
    redirect_to 'https://youtu.be/eBGIQ7ZuuiU?t=43', allow_other_host: true
  end

  # GET /edit_avatar
  def edit_avatar; end

  # PATCH /set_avatar
  def set_avatar
    if @viewer.update(avatar_params)
      redirect_to edit_avatar_path
    else
      render :edit_avatar, status: :unprocessable_entity
    end
  end

  # PATCH /remove_avatar
  def remove_avatar
    if @viewer.avatar && @viewer.update(avatar: nil)
      redirect_to edit_avatar_path
    else
      render :edit_avatar
    end
  end

  private

  def set_user
    @user = User.find(user_params[:id])
  end

  def user_params
    params.permit(:id)
  end

  def avatar_params
    params.require(:user).permit(:avatar)
  end
end
