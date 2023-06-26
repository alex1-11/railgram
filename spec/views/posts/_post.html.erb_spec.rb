require 'rails_helper'

RSpec.describe 'posts/_post', type: :view do
  subject           { rendered }
  let(:user)        { create :user }
  let(:sample_post) { create(:post, user:) }

  before do
    sign_in user
    assign(:viewer, user)
    render partial: 'posts/post', locals: { post: sample_post, likes: user.likes }
  end

  it { should have_selector("div##{dom_id sample_post}") }
  it { should have_selector("img[src='#{sample_post.image_url(:post_size)}']") }
  it { should have_link(user.name, href: user_path(user)) }
  it { should have_selector('p', text: sample_post.caption.to_s) }
  it do
    should have_selector("span[title='#{sample_post.created_at.localtime.to_fs(:long)}']",
                         text: time_ago_in_words(sample_post.created_at))
  end

  describe 'connected entities' do
    it { should render_template(partial: 'likes/like_toggle', count: 1, locals: { post: sample_post, likes: user.likes }) }
    it { should have_link('0 Comments', href: post_comments_path(sample_post)) }
    it { should render_template(partial: 'likes/likes_counter', count: 1, locals: { post: sample_post }) }

    context 'with several comments' do
      let(:comment) { create_list(:comment, 3, post: sample_post) }

      before do
        comment
        render partial: 'posts/post', locals: { post: sample_post, likes: user.likes }
      end

      it { should have_link('3 Comments', href: post_comments_path(sample_post)) }
    end
  end
end
