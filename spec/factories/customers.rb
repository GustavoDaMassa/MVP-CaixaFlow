FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.unique.email }
    address { Faker::Address.full_address }
    notes { nil }
  end
end
