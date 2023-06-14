require 'rails_helper'

RSpec.describe 'posts/show', type: :view do
  subject           { rendered }
  let(:viewer)      { create :user }
  let(:author)      { viewer }
  let(:sample_post) { create(:post, user: author) }

  before do
    sign_in viewer
    assign(:viewer, viewer)
    assign(:own_post, viewer == author)
    assign(:post, sample_post)
    assign(:likes, viewer.likes)
    render
  end

  context 'accessing user own post' do
    it 'renders the post using "_post" partial' do
      expect(view).to render_template(partial: 'posts/post',
                                      count: 1,
                                      locals: { post: sample_post, likes: viewer.likes })
    end

    it { expect(rendered).to have_link('Back') }
    it { should have_link('Edit this post', href: edit_post_path(sample_post)) }
    it { should have_selector("form[action='#{post_path(sample_post)}']") }
    it { should have_button('Destroy this post') }

    it 'destroy button inside form has turbo attributes' do
      expect(subject).to have_selector(
        "form[action='#{post_path(sample_post)}']"\
        '>button[data-turbo-confirm="Are sure you want to delete this post?"]'\
        '[data-confirm="Are sure you want to delete this post?"]'\
        '[type="submit"]'
      )
    end
  end

  context "accesing other user's post" do
    let(:author) { create :user }

    it 'renders the post using "_post" partial' do
      expect(view).to render_template(partial: 'posts/post',
                                      count: 1,
                                      locals: { post: sample_post, 
                                                likes: viewer.likes })
    end

    it { should have_link('Back') }
    it { should_not have_link('Edit this post', href: edit_post_path(sample_post)) }
    it { should_not have_selector("form[action='#{post_path(sample_post)}']") }
    it { should_not have_button('Destroy this post') }

    it do
      should_not have_selector(
        "form[action='#{post_path(sample_post)}']"\
        '>button[data-turbo-confirm="Are sure you want to delete this post?"]'\
        '[data-confirm="Are sure you want to delete this post?"]'\
        '[type="submit"]'
      )
    end
  end
end
