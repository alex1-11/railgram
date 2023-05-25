require 'rails_helper'

RSpec.describe 'users/settings', type: :view do
  subject               { rendered }
  let(:user)            { create :user }

  before do
    sign_in user
    render
  end

  it { should have_selector('h2', text: 'Account information') }
  it { should have_selector('p', text: "Name: #{user.name}") }
  it { should have_selector('p', text: "Email: #{user.email}") }
  it { should have_link('Change password', href: edit_user_registration_path) }

  it { should have_selector('h2', text: 'Danger zone') }

  it 'has button to permanently delete account after confirmation' do
    should have_selector("form[action='#{user_path(user)}'][method='post']")
    should have_selector("input[name='_method'][type='hidden'][value='delete']",
                         visible: false)

    confirmation_text = "Are really sure you want to delete your account and lose all the data and posts you made?\n"\
      'This action CAN NOT BE UNDONE!'

    button_tags = 'button[type="submit"]'\
      "[data-turbo-confirm=\"#{confirmation_text}\"]"\
      "[data-confirm=\"#{confirmation_text}\"]"

    should have_selector(button_tags, text: 'Delete my account and all the data permanently (no undo!)')
  end
end
