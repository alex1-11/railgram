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
    context 'correct image file' do
      it 'passes validation' do
        expect(post.errors).to be_empty
      end
    end

    context 'too large (size-vise) file' do
      let(:post) { create(:post, version: 'invalid_size_large') }

      it 'raises error' do
        expect { post.save }.to raise_error(ActiveRecord::RecordInvalid,
                                            'Validation failed: Image size must not be greater than 10.0 MB')
      end
    end

    context 'too small (size-vise) file' do
      let(:post) { create(:post, version: 'invalid_size_small') }

      it 'raises error' do
        expect { post.save }.to raise_error(ActiveRecord::RecordInvalid,
                                            'Validation failed: Image size must not be less than 1.0 KB')
      end
    end

    context 'wrong mime (non-image file under image extension)' do
      let(:post) { create(:post, version: 'invalid_mime') }

      it 'raises error' do
        expect { post.save }.to raise_error(ActiveRecord::RecordInvalid,
                                            'Validation failed: Image type must be one of: image/jpeg, image/png, image/webp')
      end
    end

    context 'wrong file extension' do
      let(:post) { create(:post, version: 'invalid_extention') }

      it 'raises error' do
        expect { post.save }.to raise_error(ActiveRecord::RecordInvalid,
                                            'Validation failed: Image extension must be one of: jpg, jpeg, png, webp')
      end
    end

    context 'too wide image' do
      let(:post) { create(:post, version: 'invalid_width') }

      it 'raises error' do
        expect { post.save }.to raise_error(ActiveRecord::RecordInvalid,
                                            'Validation failed: Image dimensions must not be greater than 5000x5000')
      end
    end

    context 'too high image' do
      let(:post) { create(:post, version: 'invalid_hight') }

      it 'raises error' do
        expect { post.save }.to raise_error(ActiveRecord::RecordInvalid,
                                            'Validation failed: Image dimensions must not be greater than 5000x5000')
      end
    end
  end

  describe 'derivative' do
    context 'before saving sample image to storage (promoting image, storing post instance in db`s row)' do
      let(:post) { build(:post) }
      it 'derivatives are nil' do
        expect(derivatives[:post_size]).to be_nil
      end
    end

    context 'after saving 1920x1280 image to storage (promoting)' do
      let(:post) { create(:post, image: File.open('spec/support/images/sample_1920x1280.jpg', 'rb'), image_data: {}) }

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
      let(:post) { create(:post, image: File.open('spec/support/images/sample_427x640.jpg', 'rb'), image_data: {}) }

      it 'upscales to fit 1080x1080' do
        expect(image.width).to  be < derivatives[:post_size].width
        expect(image.height).to be < derivatives[:post_size].height
        expect(derivatives[:post_size].width).to be <= 1080
        expect(derivatives[:post_size].height).to be <= 1080
      end
    end
  end
end
