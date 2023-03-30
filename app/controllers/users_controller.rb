class UsersController < ApplicationController
  # GET /users/1
  def show
    params.permit(:id)
    @user = User.find(params[:id])
    redirect_to user_posts_path(@user)
  end

  # GET /settings
  def settings; end

  # DELETE /users/1
  def destroy
    current_user.destroy
    redirect_to :root, notice: 'User was successfully destroyed.'
  end
end
