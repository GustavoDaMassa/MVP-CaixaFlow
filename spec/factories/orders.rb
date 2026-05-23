FactoryBot.define do
  factory :order do
    association :user
    customer { nil }
    status { :pending }
    total { 0 }
    notes { nil }
    scheduled_for { nil }
  end
end
