class RelationsController < ApplicationController
  before_action :set_user, only: %i[create destroy]

  # FIXME: GET /relations
  def index
    @relations = Relation.all
  end

  # POST /relations
  # TODO: make impossible to follow yourself
  def create
    @relation = current_user.follow(@user)
    update_follow_toggle
  end

  # DELETE /relations/1
  def destroy
    relation = current_user.active_relations.find(relation_params[:id])
    relation.destroy
    update_follow_toggle
  end

  private

  def set_user
    @user = User.find(relation_params[:followed_id])
  end

  def relation_params
    params.permit(:followed_id, :id)
  end

  # FIXME
  def update_follow_toggle
    # Renders new follow toggle without refreshing the page
    @user.reload
    render turbo_stream:
      [turbo_stream.replace(
        "followers_count",
        partial: 'relations/followers_counter',
        locals: { relation: @relation, user: @user }
      ),
       # FIXME: does this get executed?
       turbo_stream.replace(
        "follow_toggle",
        partial: 'relations/follow_toggle',
        locals: { relation: @relation, user: @user }
      )]
  end
end
