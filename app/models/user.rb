class User < ApplicationRecord
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
