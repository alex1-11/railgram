require 'rails_helper'

RSpec.describe 'users/followers', type: :view do
  subject         { rendered }
  let(:user)      { create :user }
  let(:relations) { create_list(:relation, 3, followed: user) }

  before do
    sign_in user
    assign(:followers, relations.map(&:follower))
    render
  end

  it { should have_selector('div#followers') }

  it 'has list of links to all followers' do
    should have_selector('ul')
    should have_link(relations[0].follower.name, href: user_path(relations[0].follower))
    should have_link(relations[1].follower.name, href: user_path(relations[1].follower))
    should have_link(relations[2].follower.name, href: user_path(relations[2].follower))
  end
end
