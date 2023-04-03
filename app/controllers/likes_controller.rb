class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @like.save
    # TODO: Make turbo frame and replace with `render` partial
    # See https://www.youtube.com/watch?v=lnSJ01chhG4&ab_channel=Deanin
    # And https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials
    update_like_toggle
    
    redirect_to @like.post, notice: 'Liked the post!'
  end

  def destroy
    @like = current_user.likes.find_by(post_id: like_params)
    @like.destroy
    redirect_to @like.post, notice: 'Unliked the post'
  end

  private

  def like_params
    params.require(:like).permit(:post_id)
  end

  def update_like_toggle
    render turbo_stream:
      turbo_stream.replace(
        'like_toggle',
        partial: 'likes/like_toggle',
        locals: { post: post }
      )
  end
end
