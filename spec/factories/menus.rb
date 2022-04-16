require 'securerandom'

FactoryBot.define do
  factory :menu do
    name { SecureRandom.base58(24) }
    price { 1.5 }
    description { Faker::Food.description[0, 149] }

    trait :with_categories do
      categories { build_list :category, 2 }
    end
  end

  factory :invalid_menu, parent: :menu do
    name { nil }
    price { 0.001 }
    description { nil }
    
    categories { |menu| [] }
  end
end
