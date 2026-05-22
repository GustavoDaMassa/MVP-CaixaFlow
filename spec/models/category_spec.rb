require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  # has_many :products validado no domínio Product
end
