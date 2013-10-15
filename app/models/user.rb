class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :posts
  has_many :user_friendships
  has_many :friends, through: :user_friendships
           
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
