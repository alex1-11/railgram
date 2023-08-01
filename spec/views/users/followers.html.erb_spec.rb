require 'rails_helper'

RSpec.describe 'users/followers', type: :view do
  subject         { rendered }
  let(:user)      { create :user }
  let(:relations) { create_list(:relation, 3, followed: user) }
  let(:followers) { relations.map(&:follower) }

  before do
    sign_in user
    assign(:user, user)
    assign(:followers, followers)
    render
  end

  it { should have_selector('h1', text: "#{user.name} - followers") }
  it { should have_link('Back to profile', href: user_path(user)) }

  it { should render_template(partial: 'users/list', count: 1, locals: { users: followers }) }

  it { should have_selector('div#users') }
  it 'has list of links to all followers' do
    should have_link(relations[0].follower.name, href: user_path(relations[0].follower))
    should have_link(relations[1].follower.name, href: user_path(relations[1].follower))
    should have_link(relations[2].follower.name, href: user_path(relations[2].follower))
  end
end
