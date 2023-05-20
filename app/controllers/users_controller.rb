class UsersController < ApplicationController
  before_action :set_user, only: %i[show followers following]
  
  # GET /users/1
  def show
    redirect_to user_posts_path(@user)
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

  private

  def set_user
    @user = User.find(user_params[:id])
  end

  def user_params
    params.permit(:id)
  end
end
