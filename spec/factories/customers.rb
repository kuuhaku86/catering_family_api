FactoryBot.define do
  factory :customer do
    email { Faker::Internet.email }

    trait :with_orders do
      orders { |customer| [customer.association(:order, :with_order_menus, :with_customer)] }
    end
  end

  factory :invalid_customer, parent: :customer do
    email { nil }

    orders { |customer| [] }
  end
end
