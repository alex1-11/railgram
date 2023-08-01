require 'rails_helper'

RSpec.describe 'users/following', type: :view do
  subject         { rendered }
  let(:user)      { create :user }
  let(:relations) { create_list(:relation, 3, follower: user) }
  let(:following) { relations.map(&:followed) }

  before do
    sign_in user
    assign(:user, user)
    assign(:following, following)
    render
  end

  it { should have_selector('h1', text: "#{user.name} is following") }
  it { should have_link('Back to profile', href: user_path(user)) }

  it { should render_template(partial: 'users/list', count: 1, locals: { users: following }) }

  it { should have_selector('div#users') }
  it 'has list of links to all followed users' do
    should have_link(relations[0].followed.name, href: user_path(relations[0].followed))
    should have_link(relations[1].followed.name, href: user_path(relations[1].followed))
    should have_link(relations[2].followed.name, href: user_path(relations[2].followed))
  end
end
