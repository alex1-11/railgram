require 'rails_helper'
require 'image_processing/vips'

RSpec.describe ImageUploader do
  let(:uploader) { described_class.new(:store) }
  let(:file) { File.open('path/to/test/image.jpg') }

  describe 'validation' do
    context 'when file is too large' do
      it 'raises an error' do
        expect { uploader.validate(file) }.to raise_error(Shrine::Error, /is too large/)
      end
    end

    context 'when file is too small' do
      it 'raises an error' do
        expect { uploader.validate(file) }.to raise_error(Shrine::Error, /is too small/)
      end
    end

    context 'when file has invalid MIME type' do
      let(:file) { File.open('path/to/test/image.gif') }

      it 'raises an error' do
        expect { uploader.validate(file) }.to raise_error(Shrine::Error, /is not a valid MIME type/)
      end
    end

    context 'when file has invalid extension' do
      let(:file) { File.open('path/to/test/image.bmp') }

      it 'raises an error' do
        expect { uploader.validate(file) }.to raise_error(Shrine::Error, /is not a valid extension/)
      end
    end

    context 'when file has valid size, MIME type, and extension' do
      it 'does not raise an error' do
        expect { uploader.validate(file) }.not_to raise_error
      end
    end
  end

  describe 'derivatives' do
    let(:original) { File.open('path/to/test/image.jpg') }
    let(:derivatives) { uploader.derivatives(original) }

    it 'creates a derivative image with a maximum width and height of 1080 pixels' do
      post_size = derivatives[:post_size]
      expect(post_size).to be_a(Shrine::UploadedFile)

      vips = ImageProcessing::Vips.source(post_size)
      expect(vips.width).to be <= 1080
      expect(vips.height).to be <= 1080
    end
  end
end
