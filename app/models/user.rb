class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  validates :username, presence: true, length: { minimum: 3 }, format: { with: /\A[a-zA-Z0-9_]+\z/ }, uniqueness: true
end
