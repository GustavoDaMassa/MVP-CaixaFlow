FactoryBot.define do
  factory :account do
    sequence(:name)      { |n| "Empresa #{n}" }
    subdomain { "empresa-#{SecureRandom.hex(4)}" }
    active { true }
  end
end
