require 'rails_helper'

RSpec.describe 'posts/new', type: :view do
  subject            { rendered }
  let(:user)         { create :user }
  let(:sample_post)  { build(:post, user:) }

  before do
    sign_in user
    assign(:post, sample_post)
    render
  end

  it 'renders the post using "_form" partial' do
    expect(view).to render_template(partial: '_form')
  end

  it { should have_selector('h1', text: 'New post') }
  it { should have_selector('input[type="submit"][name="commit"][value="Create Post"]') }
end
