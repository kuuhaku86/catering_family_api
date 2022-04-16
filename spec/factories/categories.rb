require 'securerandom'

FactoryBot.define do
  factory :category do
    name { SecureRandom.base58(24) }

    trait :with_menus do
      menus { |category| [category.association(:menu, :with_categories)] }
    end
  end

  factory :invalid_category, parent: :category do
    name { nil }

    menus { |menu| [] }
  end
end
