require 'rails_helper'

RSpec.describe 'posts/feed', type: :view do
  subject            { rendered }
  let(:user)         { create :user }
  let(:user2)        { create :user }
  let(:user3)        { create :user }
  let(:user2_posts)  { create_list(:post, 2, user: user2) }
  let(:user3_posts)  { create_list(:post, 3, user: user3) }

  before do
    sign_in user
    create(:relation, follower: user, followed: user2)
    create(:relation, follower: user, followed: user3)
    sample_posts = user2_posts.concat user3_posts
    assign(:posts, sample_posts)
    render
  end

  it { should have_selector('h1', text: 'Feed') }
  it { should have_selector('div#posts') }

  it 'renders all the posts using "_post" partial' do
    expect(view).to render_template(partial: '_post', count: 5)
  end

  it { should have_link('Show this post', href: post_path(user2_posts[0])) }
  it { should have_link('Show this post', href: post_path(user3_posts[2])) }
end
