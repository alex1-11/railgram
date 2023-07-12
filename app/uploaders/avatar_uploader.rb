require 'image_processing/vips'

class AvatarUploader < Shrine
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
      validate_dimensions [50..5000, 50..5000] # avatar dimensions max: 5000x5000, min: 50x50px
    end
  end

  # Limit avatar width and height, keeping aspect ratio
  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)
    {
      profile_pic: vips.resize_to_fill!(180, 180),
      thumbnail: vips.resize_to_fill!(50, 50),
    }
  end
end
