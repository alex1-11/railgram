require 'rails_helper'

RSpec.describe 'comments/_form', type: :view do
  subject           { rendered }
  let(:user)        { create :user }
  let(:sample_post) { create :post }
  let(:comment)     { build(:comment, user:, post_id: sample_post.id) }

  before do
    sign_in user
    render partial: 'comments/form', locals: { comment: }
  end

  it { should have_selector('div#new_comment_form') }
  it { should have_selector("form[action='/posts/1/comments'][method='post']") }

  it do
    should have_selector("input[type='hidden'][value='1'][name='comment[post_id]']"\
                         "[id='comment_post_id']",
                         visible: false)
  end

  it { should have_selector('label[for="comment_text_comment"]', text: 'Comment') }
  it { should have_selector('input[type="text"][name="comment[text]"][id="comment_text"]') }
  it { should have_selector('input[type="submit"][name="commit"][value="Send"]') }

  context 'when the new comment data has errors' do
    before do
      comment.errors.add(:text, "can't be blank")
      render partial: 'comments/form', locals: { comment: }
    end

    it { should have_selector('div[style="color: red"]') }
    it { should have_selector('h2', text: '1 error prohibited this comment from being saved:') }
    it { should have_selector('ul') }
    it { should have_selector('li', text: "Text can't be blank") }
  end
end
