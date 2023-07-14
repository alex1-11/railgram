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

  # GET /easter_egg
  def easter_egg
    current_user.roll_user
    redirect_to 'https://youtu.be/eBGIQ7ZuuiU?t=43', allow_other_host: true
  end

  # GET /edit_avatar
  def edit_avatar
  end

  # PATCH /set_avatar
  def set_avatar
    # @viewer.avatar = avatar_params[:avatar] # FIXME
    # @viewer.update_attribute(:avatar, avatar_params[:avatar]) if @viewer.valid? # FIXME
    if @viewer.update!(avatar_params)
      redirect_to user_path(@viewer)
    else
      render :edit_avatar, status: :unprocessable_entity
    end
  end

    # TODO: PATCH /remove_avatar
    def remove_avatar
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
