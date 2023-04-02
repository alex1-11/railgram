require 'rails_helper'

RSpec.describe 'home/index', type: :view do
  context 'when user is not signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
      render
    end

    it 'displays welcome message' do
      expect(rendered).to have_selector('h1', text: 'Welcome to')
    end

    it 'displays app name in h1 tag' do
      expect(rendered).to have_selector('h1', text: 'RAILGRAM ! 📸')
    end

    it 'does displays the old app name in h3 tag' do
      expect(rendered).to have_selector('h3 > del', text: 'RAILGUN 🔫')
    end
  end

  context 'when user is signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
      render
    end

    it 'does not display the welcome message' do
      expect(rendered).not_to have_selector('h1', text: 'Welcome to')
    end

    it 'does not display the app name' do
      expect(rendered).not_to have_selector('h1', text: 'RAILGRAM ! 📸')
    end

    it 'does not display the old app name in h3 tag' do
      expect(rendered).not_to have_selector('h3', text: 'RAILGUN 🔫')
    end
  end
end
