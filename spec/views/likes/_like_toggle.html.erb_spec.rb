require 'rails_helper'

RSpec.describe 'likes/_like_toggle', type: :view do
  subject     { rendered }
  let(:user)  { create :user }
  let(:post)  { create :post }
  let(:likes) { user.likes }

  before do
    sign_in user
    assign(:viewer, user)
  end

  it do
    render partial: 'likes/like_toggle', locals: { post:, likes: }
    should have_selector("turbo-frame#like_toggle_#{post.id}")
  end

  context 'the post has no likes' do
    before { render partial: 'likes/like_toggle', locals: { post:, likes: } }

    it { should have_selector("form[action='#{likes_path}'][method='post']") }
    it { should have_selector("input[name='post_id'][type='hidden'][value='#{post.id}']", visible: false) }
    it { should have_selector("button[type='submit'][class='btn btn-outline-primary rounded-circle me-1']", text: '♡') }
  end

  context 'the post is liked' do
    let(:like) { create :like, user:, post: }

    before do
      like
      likes
      render partial: 'likes/like_toggle', locals: { post:, likes: }
    end

    it { should have_selector("form[method='post'][action='#{like_path(like)}']") }
    it { should have_selector("input[type='hidden'][name='_method'][value='delete']", visible: false) }
    it { should have_selector("input[name='post_id'][type='hidden'][value='#{post.id}']", visible: false) }
    it { should have_selector("button[type='submit'][class='btn btn-primary rounded-circle me-1']", text: '♥') }
  end
end
