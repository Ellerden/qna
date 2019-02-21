FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { nil }
  end

  trait :invalid do
    body { nil }
  end
end
