require 'rails_helper'

RSpec.describe 'comments/index', type: :view do
  subject                  { rendered }
  let(:user)               { create :user }
  let(:sample_post)        { create :post }
  let(:comments)           { create_list(:comment, 3, post: sample_post) }
  let(:new_comment_record) { build(:comment, user:, post_id: sample_post.id) }

  before do
    sign_in user
    assign(:post, sample_post)
    assign(:comments, comments)
    assign(:new_comment, new_comment_record)
    render
  end

  it { should have_link('Back') }

  it "renders post's caption with author name and text" do
    should have_selector('div#caption')
    should have_selector('strong', text: sample_post.user.name)
    should have_selector('p', text: sample_post.caption)
  end

  it { should have_selector('div#comments') }
  it { should render_template(partial: '_comment', count: 1, locals: { comment: comments[0], post: sample_post }) }
  it { should render_template(partial: '_comment', count: 1, locals: { comment: comments[1], post: sample_post }) }
  it { should render_template(partial: '_comment', count: 1, locals: { comment: comments[2], post: sample_post }) }
  it { should render_template(partial: '_form', count: 1, locals: { comment: new_comment_record, post: sample_post }) }
end
