
require 'rails_helper'

RSpec.describe 'posts/_form', type: :view do
  subject           { rendered }
  let(:user)        { create :user }
  let(:sample_post) { build(:post, :empty, user:) }

  before do
    sign_in user
    render partial: 'posts/form', locals: { post: sample_post }
  end

  it { should have_selector('input#post_image[name="post[image]"][type="file"]') }
  it { should have_selector('label[for="post_caption"]', text: 'Caption') }

  context 'creating new post' do
    it { should have_selector("form[action='#{url_for([user, sample_post])}'][method='post']") }
    it { should have_selector("input[name='post[caption]'][type='text']") }
    it { should have_selector('input[type="submit"][value="Create Post"]') }
  end

  context 'updating existing post' do
    let(:sample_post) { create(:post, user:) }

    it { should have_selector("form[action='#{user_post_path(user, sample_post)}'][method='post']") }
    it { should have_selector('input[name="_method"][type="hidden"][value="patch"]', visible: false) }
    it { should have_selector("input[name='post[caption]'][type='text'][value='#{sample_post.caption}']") }
    it { should have_selector('input[type="submit"][value="Update Post"]') }
  end

  context 'when the post data has errors' do
    before do
      sample_post.errors.add(:caption, "can't be blank")
      sample_post.errors.add(:image, "can't be blank")
      render partial: 'posts/form', locals: { post: sample_post }
    end

    it 'displays the error messages' do
      expect(subject).to have_selector('div[style="color: red"]')
      expect(subject).to have_selector('h2', text: '2 errors prohibited this post from being saved:')
      expect(subject).to have_selector('ul')
      expect(subject).to have_selector('li', text: "Caption can't be blank")
      expect(subject).to have_selector('li', text: "Image can't be blank")
    end
  end
end
