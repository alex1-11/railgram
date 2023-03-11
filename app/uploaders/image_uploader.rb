require 'image_processing/vips'

class ImageUploader < Shrine
  # Plugins and uploading logic

  plugin :validation
  plugin :validation_helpers
  plugin :remove_invalid
  plugin :store_dimensions, log_subscriber: nil
  plugin :determine_mime_type, analyzer: :fastimage

  Attacher.validate do
    validate_max_size 10.megabytes
    validate_min_size 1.kilobyte
    if  validate_mime_type_inclusion(%w[image/jpeg image/png image/webp]) &&
        validate_extension_inclusion(%w[jpg jpeg png webp])
      # A guard against decompression attacks
      validate_dimensions [100..5000, 100..5000] # image dimensions max: 5000x5000, min: 100x100px
    end
  end

  # # Apply processing to the original image before storing it
  # process(:store) do |io|
  #   # Limit image width and height to 1080px, keeping aspect ratio
  #   resize_to_fill!(io.download, 1080, 1080)
  # end

  # processed = ImageProcessing::Vips
  #   .source(image)
  #   .resize_to_fill(1080, 1080)
  #   .strip
  #   .call

end
