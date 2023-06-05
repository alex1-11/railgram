class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = @viewer.likes.build(post_id: @post.id)
    @like.save
    @likes = [] << @like
    replace_like_toggle
  end

  def destroy
    @like = @viewer.likes.find(like_params[:id])
    @like.destroy
    @like = nil
    @likes = []
    replace_like_toggle
  end

  private

  def set_post
    @post = Post.find(like_params[:post_id])
  end

  def like_params
    params.permit(:post_id, :id)
  end

  def replace_like_toggle
    # Renders new like toggle without refreshing the page (Solution by Deanin https://www.youtube.com/watch?v=lnSJ01chhG4&ab_channel=Deanin)
    @post.reload
    render turbo_stream:
      turbo_stream.replace(
        "like_toggle_#{@post.id}",
        partial: 'likes/like_toggle',
        locals: { post: @post, like: @like, likes: @likes }
      )
  end
end
