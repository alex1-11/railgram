require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  subject            { rendered }
  let(:viewer)       { create :user }
  let(:user)         { viewer }
  let(:sample_posts) { create_list(:post, 5, user:) }

  before do
    sign_in viewer
    assign(:viewer, viewer)
    assign(:user, user)
    assign(:posts, sample_posts)
    assign(:likes, viewer.likes)
    render
  end

  shared_examples "correct index of user's posts" do
    it 'renders "users/_profile" partial for requested user' do
      expect(view).to render_template(partial: 'users/profile',
                                      count: 1,
                                      locals: { user: })
    end

    it 'renders all the posts using "_post" partial, each with link for show' do
      expect(view).to render_template(partial: 'posts/post',
                                      count: 5,
                                      locals: { likes: user.likes })
      sample_posts.each do |post|
        expect(view).to render_template(partial: 'posts/post',
                                        count: 1,
                                        locals: { post:,
                                                  likes: user.likes })
      end
    end
  end

  context 'accessing own profile (viewer == viewed user)' do
    it_behaves_like "correct index of user's posts"
  end

  context "accessing other user's profile" do
    let(:user) { create :user }

    it_behaves_like "correct index of user's posts"
  end
end
