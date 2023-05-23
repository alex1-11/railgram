require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  subject            { rendered }
  let(:user)         { create :user }
  let(:sample_posts) { create_list(:post, 5, user:) }

  before do
    sign_in user
    assign(:posts, sample_posts)
    assign(:user, user)
    render
  end

  it { should have_link('New post', href: new_post_path) }

  it 'renders "users/_profile" partial for requested user' do
    expect(view).to render_template(partial: 'users/_profile', count: 1)
  end

  it 'renders all the posts using "_post" partial' do
    expect(view).to render_template(partial: '_post', count: 5)
  end

  it { should have_link('Show this post', href: post_path(sample_posts[0])) }
  it { should have_link('Show this post', href: post_path(sample_posts[4])) }
end
