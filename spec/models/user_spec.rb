require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(admin: 0, atendente: 1) }
  end

  describe "defaults" do
    it "is active by default" do
      user = create(:user)
      expect(user.active).to be true
    end

    it "defaults to atendente role" do
      user = build(:user)
      expect(user).to be_atendente
    end
  end

  describe "#admin?" do
    it "returns true for admin role" do
      user = build(:user, role: :admin)
      expect(user).to be_admin
    end
  end
end
