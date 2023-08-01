require 'rails_helper'

RSpec.describe 'comments/_comment', type: :view do
  subject           { rendered }
  let(:user)        { create :user }
  let(:sample_post) { create :post }
  let(:comment)     { create :comment, post: sample_post, user: }

  before do
    sign_in user
    assign(:viewer, user)
    render partial: 'comments/comment', locals: { post: sample_post, comment: }
  end

  it { should have_selector("div#comment_#{comment.id}") }
  it { should have_selector('strong', text: user.name) }
  it { should have_selector('span', text: comment.text) }

  it do
    should have_selector("span[title='#{comment.created_at.localtime.to_fs(:long)}']",
                         text: time_ago_in_words(comment.created_at))
  end

  shared_examples 'deletable comment' do
    it { should have_selector("form[method='post'][action='#{post_comment_path(sample_post, comment)}']") }
    it { should have_selector("input[type='hidden'][name='_method'][value='delete']", visible: false) }
    it do
      should have_selector(
        "button[data-turbo-confirm='Delete this comment?']"\
              "[data-confirm='Delete this comment?']"\
              "[type='submit']"
      )
    end
  end

  context 'own comment under post' do
    it_behaves_like 'deletable comment'
  end

  context 'comment under own post' do
    let(:sample_post) { create(:post, user:) }
    let(:comment)     { create(:comment, post: sample_post) }

    it_behaves_like 'deletable comment'
  end

  context 'foreign comment under foreign post' do
    let(:sample_post) { create(:post) }
    let(:comment)     { create(:comment, post: sample_post) }

    it { should_not have_selector("form[action='#{post_comment_path(sample_post, comment)}'][method='post']") }
    it { should_not have_selector("input[name='_method'][type='hidden'][value='delete']", visible: false) }
    it do
      should_not have_selector(
        "button[type='submit']"\
        "[data-turbo-confirm='Delete this comment?']"\
        "[data-confirm='Delete this comment?']",
        text: 'x'
      )
    end
  end
end
