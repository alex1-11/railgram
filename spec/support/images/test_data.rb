# https://shrinerb.com/docs/testing#test-data

module TestData
  module_function

  def image_data
    attacher = Shrine::Attacher.new
    attacher.set(uploaded_image)

    # For derivatives processing
    attacher.set_derivatives(
      post_size:  uploaded_image
    )

    attacher.column_data # or attacher.data in case of postgres jsonb column
  end

  def uploaded_image
    file = File.open("spec/support/images/sample.jpg", binmode: true)

    # For performance we skip metadata extraction and assign test metadata
    uploaded_file = Shrine.upload(file, :store, metadata: false)
    uploaded_file.metadata.merge!(
      "size"      => File.size(file.path),
      "mime_type" => "image/jpeg",
      "filename"  => "test.jpg",
    )

    uploaded_file
  end
end
