require 'rails_helper'
require 'add_thumbnails_derivative_to_posts'

RSpec.describe 'lib/add_thumbnails_derivative_to_posts.rb' do
  let(:post) { create :post }

  it 'adds a thumbnail derivative to the image_attacher' do
    attacher = instance_double('Shrine::Attacher')
    file = instance_double('Shrine::UploadedFile')
    original_image = instance_double('ImageUploader::UploadedFile')
    thumbnail_image = instance_double('ImageUploader::UploadedFile')

    allow(post).to receive(:image_attacher).and_return(attacher)
    allow(attacher).to receive(:stored?).and_return(true)
    allow(attacher).to receive(:file).and_return(file)
    allow(file).to receive(:download).and_yield(original_image).and_return(file)
    allow(ImageProcessing::Vips).to receive(:source).with(original_image).and_return(original_image)
    allow(original_image).to receive(:resize_to_fit!).with(161, 161).and_return(thumbnail_image)
    allow(attacher).to receive(:add_derivative)
    allow(attacher).to receive(:atomic_persist).and_return(true)

    expect(attacher).to receive(:add_derivative).with(:thumbnail, thumbnail_image)
    expect(attacher).to receive(:atomic_persist)

    subject
  end

  it 'deletes orphaned thumbnail derivative on rescue' do
    attacher = instance_double('Shrine::Attacher')
    thumbnail_derivative = instance_double('Shrine::UploadedFile')

    allow(post).to receive(:image_attacher).and_return(attacher)
    allow(attacher).to receive(:stored?).and_return(true)
    allow(attacher).to receive(:file).and_return(thumbnail_derivative)
    allow(attacher).to receive(:atomic_persist).and_raise(Shrine::AttachmentChanged)

    expect(attacher).to receive(:derivatives).and_return({ thumbnail: thumbnail_derivative })
    expect(thumbnail_derivative).to receive(:delete)

    subject
  end

  it 'deletes orphaned thumbnail derivative on ActiveRecord::RecordNotFound rescue' do
    attacher = instance_double('Shrine::Attacher')
    thumbnail_derivative = instance_double('Shrine::UploadedFile')

    allow(post).to receive(:image_attacher).and_return(attacher)
    allow(attacher).to receive(:stored?).and_return(true)
    allow(attacher).to receive(:file).and_return(thumbnail_derivative)
    allow(attacher).to receive(:atomic_persist).and_raise(ActiveRecord::RecordNotFound)

    expect(attacher).to receive(:derivatives).and_return({ thumbnail: thumbnail_derivative })
    expect(thumbnail_derivative).to receive(:delete)

    subject
  end
end
