FactoryBot.define do
  factory :order_menu do
    quantity { 1 }
    total_price { 1.5 }

    association :order, factory: :order
    association :menu, factory: :menu
  end

  factory :invalid_order_menu, parent: :order_menu do
    quantity { nil }
    total_price { nil }
    order { nil }
    menu { nil }
  end
end
