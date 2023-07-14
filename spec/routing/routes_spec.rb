require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'Devise routing' do
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

  describe 'Root routing' do
    it 'routes to home#index' do
      expect(get: '/').to route_to(controller: 'home', action: 'index')
    end
  end

  describe 'Users routing' do
    it 'routes to user#show' do
      expect(get: '/users/1').to route_to(controller: 'users', action: 'show', id: '1')
    end

    it 'routes to user#destroy' do
      expect(delete: '/users/1').to route_to(controller: 'users', action: 'destroy', id: '1')
    end
  end

  describe 'Settings routing' do
    it 'routes to user#settings' do
      expect(get: '/settings').to route_to(controller: 'users', action: 'settings')
    end

    it 'has the correct named route' do
      expect(user_settings_path).to eq '/settings'
    end
  end

  describe 'Easter egg routing' do
    it 'routes to users#easter_egg' do
      expect(get: '/easter_egg').to route_to(controller: 'users', action: 'easter_egg')
    end

    it 'has the correct named route' do
      expect(easter_egg_path).to eq '/easter_egg'
    end
  end

  describe 'Avatar routing' do
    describe 'edit_avatar path' do
      it 'routes to users#edit_avatar' do
        expect(get: '/edit_avatar').to route_to(controller: 'users', action: 'edit_avatar')
      end

      it 'has the correct named route' do
        expect(edit_avatar_path).to eq '/edit_avatar'
      end
    end

    describe 'set_avatar path' do
      it 'routes to users#set_avatar' do
        expect(patch: '/set_avatar').to route_to(controller: 'users', action: 'set_avatar')
      end

      it 'has the correct named route' do
        expect(set_avatar_path).to eq '/set_avatar'
      end
    end

    describe 'remove_avatar path' do
      it 'routes to users#remove_avatar' do
        expect(patch: '/remove_avatar').to route_to(controller: 'users', action: 'remove_avatar')
      end

      it 'has the correct named route' do
        expect(remove_avatar_path).to eq '/remove_avatar'
      end
    end
  end

  describe 'Posts routing' do
    it 'routes to posts#index' do
      expect(get: '/users/1/posts').to route_to(controller: 'posts', action: 'index', user_id: '1')
    end

    it 'routes to posts#show' do
      expect(get: '/posts/1').to route_to(controller: 'posts', action: 'show', id: '1')
    end

    it 'routes to posts#new' do
      expect(get: '/posts/new').to route_to(controller: 'posts', action: 'new')
    end

    it 'routes to posts#edit' do
      expect(get: '/posts/1/edit').to route_to(controller: 'posts', action: 'edit', id: '1')
    end

    it 'routes to posts#create' do
      expect(post: '/posts').to route_to(controller: 'posts', action: 'create')
    end

    it 'routes to posts#update' do
      expect(patch: '/posts/1').to route_to(controller: 'posts', action: 'update', id: '1')
      expect(put: '/posts/1').to route_to(controller: 'posts', action: 'update', id: '1')
    end

    it 'routes to posts#destroy' do
      expect(delete: '/posts/1').to route_to(controller: 'posts', action: 'destroy', id: '1')
    end
  end

  describe 'Likes routing' do
    it 'routes to likes#create' do
      expect(post: '/likes').to route_to(controller: 'likes', action: 'create')
    end

    it 'routes to likes#destroy' do
      expect(delete: '/likes/1').to route_to(controller: 'likes', action: 'destroy', id: '1')
    end
  end

  describe 'Comments routing' do
    it 'routes to #index' do
      expect(get: '/posts/1/comments').to route_to('comments#index', post_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/posts/1/comments').to route_to('comments#create', post_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: 'posts/1/comments/1').to route_to('comments#destroy', post_id: '1', id: '1')
    end
  end

  describe 'Relations routing' do
    it 'routes to #create' do
      expect(post: 'relations').to route_to('relations#create')
    end

    it 'routes to #destroy' do
      expect(delete: 'relations/1').to route_to('relations#destroy', id: '1')
    end

    it 'routes to user#followers' do
      expect(get: 'users/1/followers').to route_to(controller: 'users', action: 'followers', id: '1')
    end

    it 'routes to user#following' do
      expect(get: 'users/1/following').to route_to(controller: 'users', action: 'following', id: '1')
    end

    it 'routes to posts#feed through "feed" named route' do
      expect(get: 'feed').to route_to('posts#feed')
      expect(feed_path).to eq '/feed'
    end
  end

  describe 'Themes routing' do
    it 'routes to "themes#light" through "light_theme" named route' do
      expect(get: 'light_theme').to route_to('themes#light')
      expect(light_theme_path).to eq '/light_theme'
    end

    it 'routes to "themes#dark" through "dark_theme" named route' do
      expect(get: 'dark_theme').to route_to('themes#dark')
      expect(dark_theme_path).to eq '/dark_theme'
    end
  end
end
