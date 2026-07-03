FactoryBot.define do
  factory :cash_register do
    association :user
    account { ActsAsTenant.current_tenant || association(:account) }
    opening_amount { 100.0 }
    opened_at { Time.current }
    closed_at { nil }
  end
end
