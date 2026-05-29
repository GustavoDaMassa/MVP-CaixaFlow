class FiscalDocument < ApplicationRecord
  belongs_to :order

  enum :status, {
    pending: 0,
    authorized: 1,
    rejected: 2,
    cancelled: 3
  }

  validates :focus_ref, presence: true, uniqueness: true
  validates :serie, :numero, presence: true

  def authorized?
    status == "authorized"
  end

  def danfe_available?
    authorized? && danfe_url.present?
  end
end
