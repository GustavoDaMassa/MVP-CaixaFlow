FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Produto #{n}" }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price(range: 5.0..100.0) }
    active { true }
    association :category
  end
end
