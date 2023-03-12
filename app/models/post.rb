class Post < ApplicationRecord
  # Shrine gem for uploading images
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  belongs_to :user
  validates :caption, length: { maximum: 2200 }
  validates :user_id, :image_data, presence: true
end
