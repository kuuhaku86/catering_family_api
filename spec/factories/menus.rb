FactoryBot.define do
  factory :menu do
    name { Faker::Food.name }
    price { 1.5 }
    description { Faker::Food.description[0, 149] }
  end

  factory :invalid_menu, parent: :menu do
    name { nil }
    price { 0.001 }
    description { nil }
  end
end
