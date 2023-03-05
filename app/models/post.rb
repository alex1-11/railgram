class Post < ApplicationRecord
  belongs_to :user

  validates :caption, length: { maximum: 2200 }
end
