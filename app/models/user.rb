class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy

  has_many :active_relations,  class_name: 'Relation',
                               foreign_key: 'follower_id',
                               dependent: :destroy
  has_many :passive_relations, class_name: 'Relation',
                               foreign_key: 'followed_id',
                               dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :name, :password, presence: true
  validates :email, :name, uniqueness: true
  validates :email, length: { in: 5..256 }
  validates :name, length: { in: 3..30 }
  validates :password, length: { minimum: 6 }
end
