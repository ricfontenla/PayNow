class Order < ApplicationRecord
  belongs_to :company
  belongs_to :final_customer
  belongs_to :product

  has_many :order_histories
  has_one :receipt

  enum choosen_payment: { boleto: 1, card: 2, pix: 3 }
  enum status: { pendente: 1, aprovado: 2 }

  before_validation :generate_token
  after_create :create_history

  ONLY_NUMBERS = /\A[0-9]+\Z/

  validates :card_number, :verification_code, format: { with: ONLY_NUMBERS }, if: :card?
  validates :token, :status, :original_price, :final_price, :choosen_payment,
            presence: true
  validates :adress, presence: true, if: :boleto?
  validates :card_number, :printed_name, :verification_code,
            presence: true, if: :card?
  validates :card_number, length: { is: 16 }, if: :card?
  validates :verification_code, length: { is: 3 }, if: :card?

  scope :by_date, ->(date) { where(created_at: date..) }
  scope :by_type, ->(type) { where(choosen_payment: type) }

  private

  def generate_token
    unless token
      new_token = SecureRandom.base58(20)
      duplicity = Order.where(token: new_token)
      generate_token if duplicity.any?
      self.token = new_token
    end
  end

  def create_history
    order_histories.create
  end
end
