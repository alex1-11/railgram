require 'rails_helper'

RSpec.describe CommentsController, type: :routing do
  describe 'comments routing' do
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
end
