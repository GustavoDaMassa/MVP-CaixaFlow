FactoryBot.define do
  factory :order do
    association :user
    customer { nil }
    payment_method { :cash }
    total { 0 }
    scheduled_for { nil }
  end
end
