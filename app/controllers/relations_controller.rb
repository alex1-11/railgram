class RelationsController < ApplicationController
  before_action :set_user

  # POST /relations
  def create
    @relation = @viewer.follow(@user) if @viewer != @user
    replace_follow_elements
  end

  # DELETE /relations/1
  def destroy
    @viewer.unfollow(@user)
    replace_follow_elements
  end

  private

  def set_user
    @user = User.find(relation_params[:followed_id])
  end

  def relation_params
    params.permit(:followed_id, :id)
  end

  def replace_follow_elements
    # Renders new follow counter and toggle without refreshing the page
    render turbo_stream:
      [
        turbo_stream.replace(
          'followers_counter',
          partial: 'relations/followers_counter',
          locals: { relation: @relation, user: @user, viewer: @viewer }
        ),
        turbo_stream.replace(
          'follow_toggle',
          partial: 'relations/follow_toggle',
          locals: { relation: @relation, user: @user, viewer: @viewer }
        )
      ]
  end
end
