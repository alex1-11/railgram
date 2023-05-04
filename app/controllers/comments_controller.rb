class CommentsController < ApplicationController
  before_action :set_post_comments, only: %i[index create]

  # GET /post/:post_id/comments
  def index
    @new_comment = current_user.comments.build(post_id: params[:post_id])
  end

  # POST /post/:post_id/comments
  def create
    @new_comment = current_user.comments.build(comment_params)
    if @new_comment.save
      redirect_to post_comments_url(@post), notice: 'You commented the post.'
    else
      render :index, status: :unprocessable_entity
    end
  end

  # DELETE /post/:post_id/comments/:id
  def destroy
    @comment = Comment.find(params[:id])
    if current_user == @comment.user || current_user == @comment.post.user
      @comment.destroy
      redirect_to post_comments_url(@comment.post), notice: 'Comment was deleted.'
    else
      redirect_to post_comments_url(@comment.post), notice: "You can't delete this comment!"
    end
  end

  private

  def set_post_comments
    @post = Post.find(params[:post_id])
    @comments = @post.comments
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:post_id, :text)
  end
end
