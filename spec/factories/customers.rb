FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.email }

    trait :with_orders do
      orders { |customer| [customer.association(:order, :with_order_menus, :with_customer)] }
    end
  end

  factory :invalid_customer, parent: :customer do
    name { nil }
    email { nil }

    orders { |customer| [] }
  end
end
