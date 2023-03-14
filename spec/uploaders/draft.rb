require 'rails_helper'
require 'image_processing/vips'

RSpec.describe ImageUploader do
  # let(:post)        { build(:post, image: File.open('spec/support/images/sample_1280x720.jpg', 'rb')) }
  # let(:image)       { post.image }
  let(:uploader) { Shrine::Attacher.new }
  let(:file) { File.open('spec/support/images/sample_1280x720.jpg', 'rb') }

  describe '#validate' do
    context 'when file is within size limits and has valid format' do
      it 'passes validation' do
        uploader.validate(file)
        expect(uploader.errors).to be_empty
      end
    end

    context 'when file is too large' do
      let(:file) { File.open('spec/support/images/sample_1280x720.jpg', 'rb') }

      it 'fails validation' do
        uploader.validate(file)
        expect(uploader.errors).to include('max size is 10 MB')
      end
    end

    context 'when file format is invalid' do
      let(:file) { File.open('spec/support/images/sample_1280x720.jpg', 'rb') }

      it 'fails validation' do
        uploader.validate(file)
        expect(uploader.errors).to include('mime type is invalid')
      end
    end

    context 'when file dimensions are invalid' do
      let(:file) { File.open('spec/support/images/sample_1280x720.jpg', 'rb') }

      it 'fails validation' do
        uploader.validate(file)
        expect(uploader.errors).to include('dimensions are invalid')
      end
    end
  end

  describe '#derivatives' do
    it 'creates derivative images' do
      derivatives = uploader.derivatives(file)
      expect(derivatives.keys).to eq([:post_size])
      expect(derivatives[:post_size]).to be_a(Shrine::UploadedFile)
      expect(derivatives[:post_size].mime_type).to eq('image/jpeg')
      expect(derivatives[:post_size].size).to be < file.size
      expect(derivatives[:post_size].width).to eq(1080)
      expect(derivatives[:post_size].height).to be <= 1080
    end
  end
end
