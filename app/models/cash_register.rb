class CashRegister < ApplicationRecord
  belongs_to :user

  validates :opening_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :opened_at, presence: true
  validate :only_one_open, on: :create

  scope :open_register, -> { where(closed_at: nil) }
  scope :recent, -> { order(opened_at: :desc) }

  def self.current
    open_register.first
  end

  def open?
    closed_at.nil?
  end

  def orders
    if open?
      Order.where("created_at >= ?", opened_at)
    else
      Order.where(created_at: opened_at..closed_at)
    end
  end

  def total_sales
    orders.sum(:total)
  end

  def duration
    endpoint = closed_at || Time.current
    ((endpoint - opened_at) / 3600).round(1)
  end

  private

  def only_one_open
    errors.add(:base, "Já existe um caixa aberto.") if CashRegister.open_register.exists?
  end
end
