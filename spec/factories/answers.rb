FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { nil }
  end

  trait :notvalid do
    body { nil }
  end
end
