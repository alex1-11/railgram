class RelationsController < ApplicationController
  before_action :set_user, only: %i[create destroy]

  # FIXME: GET /relations
  def index
    @relations = Relation.all
  end

  # POST /relations
  def create
    @relation = current_user.follow(@user) if current_user != @user
    update_follow_toggle
  end

  # DELETE /relations/1
  def destroy
    current_user.unfollow(@user)
    update_follow_toggle
  end

  private

  def set_user
    @user = User.find(relation_params[:followed_id])
  end

  def relation_params
    params.permit(:followed_id, :id)
  end

  def update_follow_toggle
    # Renders new follow toggle without refreshing the page
    render turbo_stream:
      [
        turbo_stream.replace(
          'followers_counter',
          partial: 'relations/followers_counter',
          locals: { relation: @relation, user: @user }
        ),
        turbo_stream.replace(
          'follow_toggle',
          partial: 'relations/follow_toggle',
          locals: { relation: @relation, user: @user }
        )
      ]
  end
end
