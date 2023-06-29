require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  subject      { rendered }
  let(:user)   { create :user }

  before do
    sign_in user
    assign(:viewer, user)
    assign(:user, user)
    render
  end

  it { should render_template(partial: 'users/profile', count: 1, locals: { user: }) }
end
