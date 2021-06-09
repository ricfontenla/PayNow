class PaymentMethod < ApplicationRecord
  has_one_attached :category_icon
  validates :name, :billing_fee, :max_fee, :category, presence: true
  validates :name, uniqueness: true
  validates :billing_fee, :max_fee, numericality: { greater_than_or_equal_to: 0 }
  
  after_create :set_icon

  enum category: { boleto: 1, card: 2, pix: 3 }

  scope :available, -> { where(status: true) }
  
  private
  def set_icon
    if self.boleto?
      self.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/boleto.png')), 
                filename: 'boleto.png')
    elsif self.card?
      self.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/card.png')), 
                filename: 'card.png')
    else  self.pix?
      self.category_icon
        .attach(io: File.open(Rails.root.join('app/assets/images/icons/pix.png')), 
                filename: 'pix.png')
    end
  end
end
