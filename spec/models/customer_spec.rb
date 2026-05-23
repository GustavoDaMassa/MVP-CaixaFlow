require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  # has_many :orders validado no domínio Order
end
