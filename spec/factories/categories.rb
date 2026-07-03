FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Categoria #{n}" }
    account { ActsAsTenant.current_tenant || association(:account) }
  end
end
