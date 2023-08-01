require 'rails_helper'

RSpec.describe 'users/_list', type: :view do
  subject      { rendered }
  let(:user)   { create :user }
  let(:users)  { create_list :user, 3 }
  let(:viewer) { user }

  before do
    sign_in viewer
    assign(:viewer, viewer)
    render partial: 'users/list', locals: { users: }
  end

  it { should have_selector('div#users') }

  it 'has list of links to all users' do
    should have_link(users[0].name, href: user_path(users[0]))
    should have_link(users[1].name, href: user_path(users[1]))
    should have_link(users[2].name, href: user_path(users[2]))
  end
end
