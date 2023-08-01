require 'rails_helper'
require 'add_thumbnails_derivative_to_posts'

RSpec.describe 'lib/add_thumbnails_derivative_to_posts.rb' do
  let(:posts) { create_list(:post, 3) }

  it 'adds thumbnail derivative to each post image' do
    Post.find_each do |post|
      post.image_derivatives.delete(:thumbnail)
      expect(post.image_derivatives.keys).to_not include(:thumbnail)
    end
    subject
    Post.find_each do |post|
      post.reload
      thumbnail = post.image_derivatives[:thumbnail]
      expect(thumbnail).to_not be_nil
      expect(thumbnail.width).to eq(161)
      expect(thumbnail.height).to eq(161)
    end
  end
end
