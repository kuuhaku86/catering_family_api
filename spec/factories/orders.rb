FactoryBot.define do
  factory :order do
    total_price { 1.5 }
    status { Order::STATUS[:new] }

    trait :with_customer do
      customer { create(:customer) }
    end

    trait :with_order_menus do
      order_menus { build_list :order_menu, 3 }
    end
  end

  factory :invalid_order, parent: :order do
    total_price { nil }
    status { nil }

    customer { nil }
    order_menus { |order| [] }
  end
end
