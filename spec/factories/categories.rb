FactoryBot.define do
  factory :category do
    name { Faker::Food.ethnic_category }

    trait :with_menus do
      menus { |category| [category.association(:menu, :with_categories)] }
    end
  end

  factory :invalid_category, parent: :category do
    name { nil }

    menus { |menu| [] }
  end
end
