class AddThumbnailDerivativeToPosts < ActiveRecord::Migration[7.0]
  def change
    Post.find_each do |post|
      attacher = post.image_attacher

      next unless attacher.stored?

      thumbnail = attacher.file.download do |original|
        ImageProcessing::Vips
          .source(original)
          .resize_to_fit!(161, 161)
      end

      attacher.add_derivative(:thumbnail, thumbnail)

      begin
        attacher.atomic_persist               # persist changes if attachment has not changed in the meantime
      rescue Shrine::AttachmentChanged,       # attachment has changed
             ActiveRecord::RecordNotFound     # record has been deleted
        attacher.derivatives[:thumbnail].delete  # delete now orphaned derivative
      end
    end
  end
end
