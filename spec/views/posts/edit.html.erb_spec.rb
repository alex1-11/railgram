require 'rails_helper'

RSpec.describe 'posts/edit', type: :view do
  subject            { rendered }
  let(:user)         { create :user }
  let(:sample_post)  { create(:post, user:) }

  before do
    sign_in user
    assign(:post, sample_post)
    render
  end

  it 'renders the post using "_form" partial' do
    expect(view).to render_template(partial: '_form')
  end

  it { should have_link('Show this post', href: post_path(sample_post)) }
  it { should have_link('Back to my posts', href: user_posts_path(user)) }
end
