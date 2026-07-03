class User < ApplicationRecord
  acts_as_tenant :account
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  enum :role, { admin: 0, atendente: 1 }, default: :atendente

  validates :name, presence: true

  before_create :set_active_default

  private

  def set_active_default
    self.active = true if active.nil?
  end
end
