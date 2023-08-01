require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  subject         { rendered }
  let(:user)      { create :user }
  let(:users)     { create_list(:user, 3) }

  before do
    sign_in user
    assign(:user, user)
    assign(:users, users)
    render
  end

  it { should have_selector('h1', text: 'Most popular users') }
  it { should render_template(partial: 'users/list', count: 1, locals: { users: }) }
end
