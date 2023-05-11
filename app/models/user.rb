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
  has_many :following, through: :active_relations, source: :followed

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :name, :password, presence: true
  validates :email, :name, uniqueness: true
  validates :email, length: { in: 5..256 }
  validates :name, length: { in: 3..30 }
  validates :password, length: { minimum: 6 }

  # Checks if the user is following the other user
  def follows?(other_user)
    following.include?(other_user)
  end

  # Follows user and creates relation record if not existed yet, returns relation
  def follow(other_user)
    following << other_user unless follows?(other_user)
    Relation.find_by(follower: self, followed: other_user)
  end

  # Unfollows user and destroyes relation record automatically
  def unfollow(other_user)
    if follows?(other_user)
      following.delete(other_user.id)
      true
    else
      false
    end
  end
end
