require 'rails_helper'

RSpec.describe ThemesController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #light' do
    it 'deletes the theme cookie' do
      request.env['HTTP_REFERER'] = '/previous_page'
      cookies[:theme] = 'dark'

      get :light

      expect(cookies[:theme]).to be_nil
      expect(response).to redirect_to('/previous_page')
    end

    it 'redirects to root path when referrer is nil' do
      request.env['HTTP_REFERER'] = nil

      get :light

      expect(cookies[:theme]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #dark' do
    it 'sets the theme cookie to "dark"' do
      request.env['HTTP_REFERER'] = '/previous_page'

      get :dark

      expect(cookies[:theme]).to eq('dark')
      expect(response).to redirect_to('/previous_page')
    end

    it 'redirects to root path when referrer is nil' do
      request.env['HTTP_REFERER'] = nil

      get :dark

      expect(cookies[:theme]).to eq('dark')
      expect(response).to redirect_to(root_path)
    end
  end
end
