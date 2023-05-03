require 'rails_helper'

RSpec.describe 'likes/_like_toggle', type: :view do
  subject    { rendered }
  let(:user) { create :user }
  let(:post) { create :post }

  before do
    sign_in user
    render partial: 'likes/like_toggle', locals: { post: }
  end

  it { should have_selector("turbo-frame#like_toggle_#{post.id}") }

  context 'the post has no likes' do
    it { should have_selector("form[action='#{likes_path}'][method='post']") }
    it { should have_selector("input[name='post_id'][type='hidden'][value='#{post.id}']", visible: false) }
    it { should have_selector("button[type='submit']", text: 'Like') }
  end

  context 'the post is liked' do
    let(:like) { create :like, user:, post: }

    before do
      like
      render partial: 'likes/like_toggle', locals: { post: }
    end

    it { should have_selector("form[action='#{like_path(post.likes.find_by(user_id: user.id))}'][method='post']") }
    it { should have_selector("input[name='_method'][type='hidden'][value='delete']", visible: false) }
    it { should have_selector("input[name='post_id'][type='hidden'][value='#{post.id}']", visible: false) }
    it { should have_selector("button[type='submit']", text: 'Unlike') }
    it { should have_selector('p', text: '1 Like') }

    context 'the post has several likes' do
      let(:like) do
        create(:like, user:, post:)
        create_list(:like, 4, post:)
      end

      it { should have_selector('p', text: '5 Likes') }
    end
  end
end
