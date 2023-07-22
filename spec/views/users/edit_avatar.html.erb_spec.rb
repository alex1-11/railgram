# spec/views/users/edit_avatar.html.erb_spec.rb
require 'rails_helper'

RSpec.describe 'users/edit_avatar', type: :view do
  let(:user) { create(:user, :with_avatar) }

  before do
    sign_in user
    assign(:viewer, user)
    assign(:set_avatar_url, set_avatar_path)
    render
  end

  it 'displays the "Back" link' do
    expect(rendered).to have_link('Back')
  end

  context 'when viewer has errors' do
    before do
      user.errors.add(:avatar, 'must be an image')
      user.errors.add(:avatar, 'is too large')
      render
    end

    it 'displays the error messages' do
      expect(rendered).to have_selector('.alert.alert-danger', count: 1)
      expect(rendered).to have_content('2 errors prohibited new avatar from being saved:')
      expect(rendered).to have_content('Avatar must be an image')
      expect(rendered).to have_content('Avatar is too large')
    end
  end

  context 'when viewer has an avatar' do
    it 'displays the avatar image' do
      expect(rendered).to have_css("img[src*='#{user.avatar_url(:profile_pic)}']")
    end

    it 'displays the "Remove avatar" button' do
      expect(rendered).to have_button('Remove avatar')
    end
  end

  context 'when viewer does not have an avatar' do
    let(:user) { create(:user) }

    it 'displays the default avatar image' do
      expect(rendered).to have_css("img[src*='default_avatar']")
    end
  end

  it 'displays the "Set avatar" form' do
    expect(rendered).to have_selector('form#set_avatar')
    expect(rendered).to have_selector('input#user_avatar[required="required"][type="file"][name="user[avatar]"]')
    expect(rendered).to have_button('Set avatar', type: 'submit')
  end
end
