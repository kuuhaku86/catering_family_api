FactoryBot.define do
  factory :category do
    name { Faker::Food.ethnic_category }

    trait :with_menus do
      menus { build_list :menu, 3 }
    end
  end

  factory :invalid_category, parent: :category do
    name { nil }
  end
end
