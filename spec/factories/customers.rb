FactoryBot.define do
  factory :customer do
    name { "Name" }
    email { "abc@gmail.com" }

    trait :with_orders do
      orders { build_list :order, 3 }
    end
  end

  factory :invalid_customer, parent: :customer do
    name { nil }
    email { nil }

    orders { |customer| [] }
  end
end
