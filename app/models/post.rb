class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  # Shrine gem for uploading images
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  validates :caption, length: { maximum: 2200 }
  validates :user_id, :image_data, presence: true
end
