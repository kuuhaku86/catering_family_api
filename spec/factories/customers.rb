FactoryBot.define do
  factory :customer do
    name { "Name" }
    email { "abc@gmail.com" }
  end

  factory :invalid_customer, parent: :customer do
    name { nil }
    email { nil }
  end
end
