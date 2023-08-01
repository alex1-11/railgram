class ChangeImageDerivativesLogic < ActiveRecord::Migration[7.0]
  def change
    Post.find_each do |post|
      attacher = post.image_attacher

      next unless attacher.stored?

      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})                    # clear derivatives
      attacher.create_derivatives                     # reprocess derivatives

      begin
        attacher.atomic_persist                       # persist changes if attachment has not changed in the meantime
        attacher.delete_derivatives(old_derivatives)  # delete old derivatives
      rescue Shrine::AttachmentChanged,               # attachment has changed
             ActiveRecord::RecordNotFound             # record has been deleted
        attacher.delete_derivatives                   # delete now orphaned derivatives
      end
    end
  end
end
