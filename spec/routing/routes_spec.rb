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
  end

  describe 'Settings routes' do
    it 'routes to user#settings' do
      expect(get: '/settings').to route_to(controller: 'users', action: 'settings')
    end

    it 'has the correct named route' do
      expect(user_settings_path).to eq '/settings'
    end
  end

  describe 'Post routes' do
    it 'routes to posts#index' do
      expect(get: '/users/1/posts').to route_to(controller: 'posts', action: 'index', user_id: '1')
    end

    it 'routes to posts#show' do
      expect(get: '/users/1/posts/1').to route_to(controller: 'posts', action: 'show', user_id: '1', id: '1')
    end

    it 'routes to posts#new' do
      expect(get: '/users/1/posts/new').to route_to(controller: 'posts', action: 'new', user_id: '1')
    end

    it 'routes to posts#edit' do
      expect(get: '/users/1/posts/1/edit').to route_to(controller: 'posts', action: 'edit', user_id: '1', id: '1')
    end

    it 'routes to posts#create' do
      expect(post: '/users/1/posts').to route_to(controller: 'posts', action: 'create', user_id: '1')
    end

    it 'routes to posts#update' do
      expect(patch: '/users/1/posts/1').to route_to(controller: 'posts', action: 'update', user_id: '1', id: '1')
      expect(put: '/users/1/posts/1').to route_to(controller: 'posts', action: 'update', user_id: '1', id: '1')
    end

    it 'routes to posts#destroy' do
      expect(delete: '/users/1/posts/1').to route_to(controller: 'posts', action: 'destroy', user_id: '1', id: '1')
    end
  end

  describe 'Like routes' do
    it 'routes to likes#create' do
      expect(post: '/likes').to route_to(controller: 'likes', action: 'create')
    end

    it 'routes to likes#destroy' do
      expect(delete: '/likes/1').to route_to(controller: 'likes', action: 'destroy', id: '1')
    end
  end
end
