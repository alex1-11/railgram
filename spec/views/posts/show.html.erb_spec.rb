require 'rails_helper'

RSpec.describe 'posts/show', type: :view do
  subject            { rendered }
  let(:user)         { create :user }
  let(:sample_post)  { create(:post, user:) }

  before do
    sign_in user
    assign(:post, sample_post)
    render
  end

  it 'renders the post using "_post" partial' do
    expect(view).to render_template(partial: '_post', count: 1)
  end

  it { should have_link('Edit this post', href: edit_user_post_path(user, sample_post)) }
  it { should have_link('Back to posts', href: user_posts_path(user)) }
  it { should have_link('Destroy this post', href: user_post_path(user, sample_post)) }

  it 'has a delete link with turbo attributes' do
    expect(rendered).to have_selector('a[data-turbo-method="delete"]' \
      '[data-turbo-confirm="Are sure you want to delete this post?"]')
  end
end
