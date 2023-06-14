class Post < ApplicationRecord
  after_initialize :set_default_counter_cache_values

  belongs_to :user, counter_cache: true
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  # Shrine gem for uploading images
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  validates :caption, length: { maximum: 2200 }
  validates :user_id, :image_data, presence: true

  def set_default_counter_cache_values
    self.likes_count ||= 0
    self.comments_count ||= 0
  end
end
