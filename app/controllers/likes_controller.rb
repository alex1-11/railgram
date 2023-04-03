# TODO: Make turbo frame and replace with `render` partial
# See https://www.youtube.com/watch?v=lnSJ01chhG4&ab_channel=Deanin
# And https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials
class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @like.save
    update_like_toggle
  end

  def destroy
    @like = current_user.likes.find_by(post_id: like_params)
    @like.destroy
    update_like_toggle
  end

  private

  def like_params
    debugger
    params.require(:post).permit(:post_id)
  end

  def update_like_toggle
    @post = Post.all.find(like_params)
    render turbo_stream:
      turbo_stream.replace(
        'like_toggle',
        partial: 'likes/like_toggle',
        locals: { post: @post }
      )
  end
end
