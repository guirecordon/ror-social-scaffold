class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, confirmation: { case_sensitive: true }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :reverse_friendships, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friends
    friends_array = reverse_friendships.map { |friendship| friendship.friend if friendship.confirmed }
    inverse_friends_array = inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    total_friends_array = friends_array + inverse_friends_array
    total_friends_array.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end

  def friend?(user)
    friends.include?(user)
  end

  def friendships
    r = reverse_friendships.map { |friendship| friendship.friend if friendship.confirmed }
    i = inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    (r + i).compact
  end

  private

  # Users who have yet to confirme friend requests
  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end
end
