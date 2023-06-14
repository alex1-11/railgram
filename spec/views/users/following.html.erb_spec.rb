require 'rails_helper'

RSpec.describe 'users/following', type: :view do
  subject         { rendered }
  let(:user)      { create :user }
  let(:relations) { create_list(:relation, 3, follower: user) }

  before do
    sign_in user
    assign(:following, relations.map(&:followed))
    render
  end

  it { should have_link('Back') }
  it { should have_selector('div#following') }

  it 'has list of links to all followed users' do
    should have_selector('ul')
    should have_link(relations[0].followed.name, href: user_path(relations[0].followed))
    should have_link(relations[1].followed.name, href: user_path(relations[1].followed))
    should have_link(relations[2].followed.name, href: user_path(relations[2].followed))
  end
end
