FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Produto #{n}" }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price(range: 5.0..100.0) }
    stock { 20 }
    low_stock_threshold { 10 }
    active { true }
    association :category

    trait :low_stock do
      stock { 5 }
      low_stock_threshold { 10 }
    end

    trait :out_of_stock do
      stock { 0 }
    end
  end
end
