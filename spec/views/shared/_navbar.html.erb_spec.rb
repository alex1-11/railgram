require 'rails_helper'

RSpec.describe 'shared/_navbar', type: :view do
  subject    { rendered }
  let(:user) { create :user }

  context 'user logged in' do
    before do
      sign_in user
      assign(:viewer, user)
      render
    end

    it 'renders partial template "_navbar" 1 time' do
      expect(view).to render_template(partial: '_navbar', count: 1)
    end

    it { should_not have_link('Sign in', href: new_user_session_path) }
    it { should_not have_link('Register', href: new_user_registration_path) }

    it { should have_link('Feed', href: feed_path) }
    it { should have_link(user.name, href: user_path(user)) }
    it { should have_link('Settings', href: user_settings_path) }
    it 'have link to destroy user session with turbo attribute' do
      should have_link('Log out', href: destroy_user_session_path)
      should have_selector("a[data-turbo-method='delete'][href='#{destroy_user_session_path}']")
    end
  end

  context 'user logged out' do
    before { render }

    it 'renders partial template "_navbar" 1 time' do
      expect(view).to render_template(partial: '_navbar', count: 1)
    end

    it { should have_link('Sign in', href: new_user_session_path) }
    it { should have_link('Register', href: new_user_registration_path) }

    it { should_not have_link('Feed', href: feed_path) }
    it { should_not have_link(user.name, href: user_path(user)) }
    it { should_not have_link('Settings', href: user_settings_path) }
    it 'does not have link to destroy user session with turbo attribute' do
      should_not have_link('Log out', href: destroy_user_session_path)
      should_not have_selector("a[data-turbo-method='delete'][href='#{destroy_user_session_path}']")
    end

  end
end
