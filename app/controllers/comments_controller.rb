class CommentsController < ApplicationController
  # GET /comments
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
  end

  # GET /comments/new
  def new
    # @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(post_id: params[:post_id])
  end

  # POST /comments
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to comment_url(@comment), notice: 'You commented the post.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])
    if current_user == comment.user || current_user == comment.post.user
      @comment.destroy
      redirect_to comments_url, notice: 'Comment was successfully destroyed.'
    else
      redirect_to post_url(comment.post), warning: "You can't delete this comment!"
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end
end
