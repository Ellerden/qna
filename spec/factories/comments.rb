FactoryBot.define do
  factory :comment do
    body { "MyComment" }

    trait :invalid do
      body { nil }
    end
  end
end
