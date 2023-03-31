require 'rails_helper'

RSpec.describe 'posts/show', type: :view do
  subject            { rendered }
  let(:user)         { create :user }
  let(:sample_post)  { create(:post, user:) }
  let(:author) { user }

  before do
    sign_in user
    assign(:user, author)
    assign(:post, sample_post)
    render
  end

  context 'accessing user own post' do
    it 'renders the post using "_post" partial' do
      expect(view).to render_template(partial: '_post', count: 1)
    end

    it { should have_link("Back to #{author.name}'s posts", href: :back) }

    it { should have_link('Edit this post', href: edit_user_post_path(author, sample_post)) }
    it { should have_link('Destroy this post', href: user_post_path(author, sample_post)) }

    it 'delete link has turbo attributes' do
      expect(rendered).to have_selector('a[data-turbo-method="delete"]'\
        '[data-turbo-confirm="Are sure you want to delete this post?"]'\
        '[confirm="Are sure you want to delete this post?"]')
    end
  end

  context "accesing other user's post" do
    let(:author)      { create :user }
    let(:sample_post) { create :post, user: author }
    it 'renders the post using "_post" partial' do
      expect(view).to render_template(partial: '_post', count: 1)
    end

    it { should have_link("Back to #{author.name}'s posts", href: :back) }
  end
end
