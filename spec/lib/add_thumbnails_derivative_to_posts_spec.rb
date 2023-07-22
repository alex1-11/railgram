require 'rails_helper'

RSpec.describe 'lib/add_thumbnails_derivative_to_posts.rb' do
  let(:posts) { create_list(:post, 3) }

  before do
    posts.each do |post|
      post.image_derivatives.delete(:thumbnail)
    end
  end

  it 'adds thumbnail derivative to each post image' do
    subject
    posts.each do |post|
      post.reload
      thumbnail = post.image_derivatives[:thumbnail]
      expect(thumbnail).to_not be_nil
      expect(thumbnail.width).to eq(161)
      expect(thumbnail.height).to eq(161)
    end
  end
end
