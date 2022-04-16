FactoryBot.define do
  factory :order_menu do
    quantity { 1 }
    total_price { 1.5 }
  end

  factory :invalid_order_menu, parent: :order_menu do
    quantity { nil }
    total_price { nil }
  end
end
