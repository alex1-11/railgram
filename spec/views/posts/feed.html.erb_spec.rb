require 'rails_helper'

RSpec.describe 'posts/feed', type: :view do
  subject                     { rendered }
  let(:user)                  { create :user }
  let(:user2)                 { create :user }
  let(:user3)                 { create :user }
  let(:user2_posts)           { create_list(:post, 2, user: user2) }
  let(:user3_posts)           { create_list(:post, 3, user: user3) }
  let(:feed_posts_collection) { user2_posts.concat user3_posts }

  before do
    sign_in user
    create(:relation, follower: user, followed: user2)
    create(:relation, follower: user, followed: user3)
    assign(:posts, feed_posts_collection)
    assign(:likes, user.likes)
    render
  end

  it { should have_selector('h1', text: 'Feed') }
  it { should have_selector('div#posts') }

  it 'renders all the posts using "_post" partial with link for showing each one' do
    expect(view).to render_template(partial: 'posts/post',
                                    count: 5,
                                    locals: { likes: user.likes })

    feed_posts_collection.each do |feed_post|
      expect(view).to render_template(partial: 'posts/post',
                                      count: 1,
                                      locals: { post: feed_post,
                                                likes: user.likes })
      should have_link('Show this post', href: post_path(feed_post))
    end
  end
end
