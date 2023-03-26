require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  subject            { rendered }
  let(:user)         { create :user }
  let(:sample_posts) { create_list(:post, 5, user:) }

  before do
    sign_in user
    assign(:posts, sample_posts)
    render
  end

  it { should have_link('New post', href: new_user_post_path(user)) }
  it { should have_selector('h1', text: 'My posts') }
  
  it 'renders all the posts using "_post" partial' do
    expect(view).to render_template(partial: '_post', count: 5)
  end

  it { should have_link('Show this post', href: user_post_path(user, sample_posts[0])) }
  it { should have_link('Show this post', href: user_post_path(user, sample_posts[4])) }
end
