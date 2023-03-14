require 'rails_helper'
require 'image_processing/vips'

RSpec.describe ImageUploader do
  let(:post)        { create(:post, image: File.open('spec/support/images/sample_1280x720.jpg', 'rb')) }
  let(:image)       { post.image }
  let(:derivatives) { post.image_derivatives }

  it 'extracts metadata' do
    expect(image.mime_type).to eq('image/jpeg')
    expect(image.extension).to eq('jpg')
    expect(image.size).to be_instance_of(Integer)
    expect(image.width).to be_instance_of(Integer)
    expect(image.height).to be_instance_of(Integer)
  end

  describe 'validation' do
    let(:image) { TestData.uploaded_image('valid') }

    it 'passes validation' do
      expect(image).to be_empty
    end

    context 'with too large image' do
      let(:image) { TestData.uploaded_image('invalid_size_large') }
      it 'adds error' do
        print image.metadata['size']
        expect(image).to include?('is too large')
      end
    end

  end

  describe 'derivative' do
    context 'before saving sample image to storage (promotoing image, storing post instance in db`s row)'
    it 'is nil' do
      expect(derivatives[:post_size]).to be_nil
    end

    context 'after saving 1920x1280 image to storage (promoting)' do
      let(:post) { create(:post, image: File.open('spec/support/images/sample_1920x1280.jpg', 'rb'))}

      it 'generates derivative image' do
        expect(derivatives[:post_size]).to be_kind_of(Shrine::UploadedFile)
      end

      it 'resizes to fit 1080x1080' do
        expect(image.width).to eq(1920)
        expect(image.height).to eq(1280)
        expect(derivatives[:post_size].width).to be <= 1080
        expect(derivatives[:post_size].height).to be <= 1080
      end
    end

    context 'after saving 427x640 image to storage (promoting)' do
      let(:post) { create(:post, image: File.open('spec/support/images/sample_427x640.jpg', 'rb'))}

      it 'upscales to fit 1080x1080' do
        expect(image.width).to  be < derivatives[:post_size].width
        expect(image.height).to be < derivatives[:post_size].height
        expect(derivatives[:post_size].width).to be <= 1080
        expect(derivatives[:post_size].height).to be <= 1080
      end
    end
  end
end
