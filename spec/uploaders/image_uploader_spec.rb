require 'rails_helper'
require 'image_processing/vips'

RSpec.describe ImageUploader do
  let(:image)       { post.image }
  let(:derivatives) { post.image_derivatives }
  let(:post)        { Post.create(image: File.open('spec/support/image/sample.jpg', 'rb')) }

  it 'extracts metadata' do
    expect(image.mime_type).to eq('image/png')
    expect(image.extension).to eq('png')
    expect(image.size).to be_instance_of(Integer)
    expect(image.width).to be_instance_of(Integer)
    expect(image.height).to be_instance_of(Integer)
  end

  it 'validates'

  it 'generates derivatives' do
    expect(derivatives[:post_size]).to be_kind_of(Shrine::UploadedFile)
  end
end
