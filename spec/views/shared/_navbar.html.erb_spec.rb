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
    it { should have_link('Users', href: users_path) }
    it { should have_link('Make a post', href: new_post_path) }
    it { should have_link(user.name, href: user_path(user)) }
    it { should have_link('Settings', href: user_settings_path) }
    it 'have link to destroy user session with turbo attribute' do
      should have_link('Log out', href: destroy_user_session_path)
      should have_selector("a[data-turbo-method='delete'][href='#{destroy_user_session_path}']")
    end

    context 'user is not rolled yet' do
      it { should have_selector("a[href='#{easter_egg_path}'][target='_blank']", text: '🤫🔎🥚') }
    end

    context 'user is already rolled' do
      let(:user) do
        u = create :user
        u.roll_user
        u
      end

      it { should_not have_link('🤫🔎🥚', href: easter_egg_path) }
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

    it 'does not render the light theme link' do
      should_not have_link('', href: dark_theme_path)
      should_not have_css('svg.bi-sun')
    end

    it 'does not render the dark theme link' do
      should_not have_link('', href: light_theme_path)
      should_not have_css('svg.bi-moon')
    end
  end

  describe 'theme switcher for logged in user' do
    before do
      sign_in user
      assign(:viewer, user)
      allow(view).to receive(:cookies).and_return(theme:)
      render
    end

    shared_examples 'light themed view' do
      it 'renders the light theme link' do
        expect(rendered).to have_link('', href: dark_theme_path)
        expect(rendered).to have_css('svg.bi-sun')
      end

      it 'does not render the dark theme link' do
        expect(rendered).not_to have_link('', href: light_theme_path)
        expect(rendered).not_to have_css('svg.bi-moon')
      end
    end

    context 'when theme is set to light' do
      let(:theme) { 'light' }

      it_behaves_like 'light themed view'
    end

    context 'when theme is unset' do
      let(:theme) { nil }

      it_behaves_like 'light themed view'
    end

    context 'when theme is set to dark' do
      let(:theme) { 'dark' }

      it 'renders the dark theme link' do
        expect(rendered).to have_link('', href: light_theme_path)
        expect(rendered).to have_css('svg.bi-moon')
      end

      it 'does not render the light theme link' do
        expect(rendered).not_to have_link('', href: dark_theme_path)
        expect(rendered).not_to have_css('svg.bi-sun')
      end
    end
  end
end
