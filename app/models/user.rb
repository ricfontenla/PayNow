class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, customer_admin: 10 }

  INVALID_DOMAINS = /\b[A-Z0-9._%a-z\-]+@(google|yahoo|hotmail)/
  
  validates :email, format: { without: INVALID_DOMAINS }
end
