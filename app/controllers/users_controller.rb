class UsersController < ApplicationController
  before_action :set_user, only: %i[show followers following]

  # GET /users/1
  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  # GET /settings
  def settings; end

  # DELETE /users/1
  def destroy
    current_user.destroy
    redirect_to :root, notice: 'User was successfully destroyed.'
  end

  def followers
    @followers = @user.followers
  end

  def following
    @following = @user.following
  end

  def easter_egg
    @user.roll_user
    redirect_to 'https://youtu.be/eBGIQ7ZuuiU?t=43'
  end

  private

  def set_user
    @user = User.find(user_params[:id])
  end

  def user_params
    params.permit(:id)
  end
end
