require 'rails_helper'

RSpec.describe 'posts/_post', type: :view do
  subject           { rendered }
  let(:user)        { create :user }
  let(:sample_post) { create(:post, user:) }

  before do
    sign_in user
    render partial: 'posts/post', locals: { post: sample_post }
  end

  it { should have_selector("div##{dom_id sample_post}") }
  it { should have_selector("img[src='#{sample_post.image_url(:post_size)}']") }
  it { should have_selector('strong', text: sample_post.user.name.to_s) }
  it { should have_selector('p', text: sample_post.caption.to_s) }
end
