# Sample testing images by Thorsten Schulze from Pixabay (https://pixabay.com/users/thorsten1970-11841595/)
# Testing documentation and hints https://shrinerb.com/docs/testing#test-data

module TestData
  module_function

  def image_data(version = 'valid')
    attacher = Shrine::Attacher.new
    attacher.set(uploaded_image(version))

    # Assign derivatives explicitly, to skip image processing
    attacher.set_derivatives(
      post_size: uploaded_image(version)
    )

    attacher.column_data # or attacher.data in case of postgres jsonb column
  end

  def uploaded_image(version = 'valid')
    file = File.open('spec/support/images/sample_1280x720.jpg', binmode: true)

    # Metadata to assign depending on requested file version
    extract_real_metadata = version == 'real_metadata'

    common_data = {
      'size' => File.size(file.path),
      'mime_type' => 'image/jpeg',
      'filename' => 'test.jpg',
      'width' => 1280,
      'height' => 720
    }

    data_versions = {
      'valid' => common_data,
      'invalid_size_large' => common_data.merge('size' => 11.megabytes),
      'invalid_size_small' => common_data.merge('size' => 100.bytes),
      'invalid_mime' => common_data.merge('mime_type' => 'text/plain'),
      'invalid_extention' => common_data.merge('filename' => 'test.txt'),
      'invalid_hight' => common_data.merge('width' => 100, 'height' => 5001),
      'invalid_width' => common_data.merge('width' => 5001, 'height' => 100)
    }

    # For performance we skip metadata extraction and assign test metadata
    uploaded_file = Shrine.upload(file, :store, metadata: extract_real_metadata)
    uploaded_file.metadata.merge!(data_versions[version]) unless extract_real_metadata
    uploaded_file
  end
end
