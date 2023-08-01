require 'rails_helper'

RSpec.describe 'likes/_likes_counter', type: :view do
  subject     { rendered }
  # Preset vars to render view
  let(:user)  { create :user }
  let(:post)  { create :post }

  before do
    sign_in user
    assign(:viewer, user)
  end

  it do
    render partial: 'likes/likes_counter', locals: { post: }
    should have_selector("turbo-frame#likes_counter_#{post.id}")
  end

  context 'the post has no likes' do
    before { render partial: 'likes/likes_counter', locals: { post: } }

    it { should_not have_selector('p', text: '0 Likes') }
    it { should have_selector("turbo-frame#likes_counter_#{post.id}", text: '') }
  end

  context 'the post is liked' do
    let(:like) { create :like, user:, post: }

    before do
      like
      render partial: 'likes/likes_counter', locals: { post: }
    end

    it { should have_selector("turbo-frame#likes_counter_#{post.id}>span", text: '1 Like') }

    context 'the post has several likes' do
      let(:like) do
        create(:like, user:, post:)
        create_list(:like, 4, post:)
      end

      it { should have_selector("turbo-frame#likes_counter_#{post.id}>span", text: '5 Likes') }
    end
  end
end
