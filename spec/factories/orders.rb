FactoryBot.define do
  factory :order do
    total_price { 1.5 }
    status { "new" }

    association :customer, factory: :customer
  end

  factory :invalid_order, parent: :order do
    total_price { nil }
    status { nil }

    customer { nil }
  end
end
