class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :posts
  
  has_many :user_friendships
  has_many :friends, through: :user_friendships,
                     conditions: { user_friendships: {state: "accepted"}}
                     
  has_many :pending_user_friendships, class_name: 'UserFriendship', 
                                      foreign_key: :user_id, 
                                      conditions: { state: 'pending'}
  has_many :pending_friends, through: :pending_user_friendships, 
                             source: :friend
           
  validates :profile_name, presence: true,
                               uniqueness: true,
                               format: {
                                 with: /\A[a-zA-Z0-9_-]+\z/,
                                 message: 'Must be formatted correctly.'
                               }
                               
  def to_param
    profile_name
  end
  
end
