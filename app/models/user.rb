class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true

  before_create :verify_user_email_domain

  INVALID_DOMAINS = /\b[A-Z0-9._%a-z\-]+@(google|yahoo|hotmail|paynow)/
  validates :email, format: { without: INVALID_DOMAINS }

  enum role: { customer: 0, customer_admin: 10 }

  def active_for_authentication?
    super && status?
  end

  private

  def verify_user_email_domain
    domain = email.split('@').last
    registered_companies = Company.where(email_domain: domain)
    self.company = registered_companies.last if registered_companies.one?
  end
end
