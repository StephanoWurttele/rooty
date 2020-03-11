class User < ApplicationRecord
  has_many :routes

  # has_many :friends, dependent: :destroy
  has_many :user_friends, foreign_key: :user_friend_id, class_name: "Friend"
  has_many :friends, through: :user_friends
  # has_and_belongs_to_many :friends,  class_name: "User", join_table:  :friends, foreign_key: :user_id, association_foreign_key: :friend_user_id

  has_many :participants
  has_many :events, through: :routes

  has_one_attached :photo

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def events_joined
    ((Participant.where(user: self)).map { |participant| participant.event } + events).uniq
  end

  def friend_requests
    self.user_friends
    #Friend.where(user_friend_id: self.id).where(accepted: false)
  end

  def friend?(friend)
    self.friend_list.include?(friend)
  end

  def friend_list
    self.user_friends + Friend.where(user_id: self.id).where(accepted: true).select(:user_friend_id)
  end

end
