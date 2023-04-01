require 'rails_helper'

RSpec.describe 'posts/show', type: :view do
  subject              { rendered }
  let(:logged_in_user) { create :user }
  let(:author)         { logged_in_user }
  let(:sample_post)    { create(:post, user: author) }

  before do
    sign_in logged_in_user
    assign(:user, author)
    assign(:post, sample_post)
    render
  end

  context 'accessing user own post' do
    it 'renders the post using "_post" partial' do
      expect(view).to render_template(partial: '_post', count: 1)
    end

    it { should have_link("Back to #{author.name}'s posts", href: user_posts_path(author)) }
    it { should have_link('Edit this post', href: edit_user_post_path(author, sample_post)) }
    it { should have_selector("form[action='#{user_post_path(author, sample_post)}']") }
    it { should have_button('Destroy this post') }

    it 'destroy button has turbo attributes' do
      expect(subject).to have_selector(
        'button[data-turbo-confirm="Are sure you want to delete this post?"]'\
        '[data-confirm="Are sure you want to delete this post?"]'\
        '[type="submit"]'
      )
    end
  end

  context "accesing other user's post" do
    let(:author) { create :user }

    it 'renders the post using "_post" partial' do
      expect(view).to render_template(partial: '_post', count: 1)
    end

    it { should have_link("Back to #{author.name}'s posts", href: user_posts_path(author)) }
  end
end
