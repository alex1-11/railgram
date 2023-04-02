require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'Devise routes' do
    it 'routes to devise sessions' do
      expect(get: '/users/sign_in').to route_to(controller: 'devise/sessions', action: 'new')
    end

    it 'routes to devise registrations' do
      expect(get: '/users/sign_up').to route_to(controller: 'devise/registrations', action: 'new')
    end

    it 'routes to devise passwords' do
      expect(get: '/users/password/new').to route_to(controller: 'devise/passwords', action: 'new')
    end
  end

  describe 'Home routes' do
    it 'routes to home#index' do
      expect(get: '/').to route_to(controller: 'home', action: 'index')
    end
  end

  describe 'User routes' do
    it 'routes to user#show' do
      expect(get: '/users/1').to route_to(controller: 'users', action: 'show', id: '1')
    end

    it 'routes to user#destroy' do
      expect(delete: '/users/1').to route_to(controller: 'users', action: 'destroy', id: '1')
    end

    it 'routes to user#posts' do
      expect(get: '/users/1/posts').to route_to(controller: 'posts', action: 'index', user_id: '1')
    end
  end

  describe 'Settings routes' do
    it 'routes to user#settings' do
      expect(get: '/settings').to route_to(controller: 'users', action: 'settings')
    end

    it 'has the correct named route' do
      expect(user_settings_path).to eq '/settings'
    end
  end
end
