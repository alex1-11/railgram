require 'rails_helper'

RSpec.describe 'posts/_form.html.erb', type: :view do
  let(:user)        { create :user }
  let(:sample_post) { create :post, user:}

  before { sign_in user }

  it 'displays the form for post' do
    assign(:post, sample_post)

    render

    expect(rendered).to have_
  end
  
end
