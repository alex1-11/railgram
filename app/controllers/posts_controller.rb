class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]

  # GET /users/:user_id/posts
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.order(created_at: :desc)
    @likes = @viewer.likes
  end

  # GET /posts/1
  def show
    @post = Post.includes(:user).find(params[:id])
    @own_post = @post.user_id == @viewer.id
    @likes = @viewer.likes
  end

  # GET /posts/new
  def new
    @post = @viewer.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = @viewer.posts.build(post_params)
    if @post.save
      redirect_to user_posts_url(@viewer), notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to user_posts_url(@viewer), notice: 'Post was successfully deleted.'
  end

  # GET /feed
  def feed
    following_ids = @viewer.following_ids << @viewer.id
    @posts = Post.includes(:user).where(user_id: following_ids).order(created_at: :desc)
    @likes = @viewer.likes
  end

  private

  def set_post
    @post = @viewer.posts.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:image, :caption, :user_id)
  end
end
