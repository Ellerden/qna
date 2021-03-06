# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "AnswerText#{n}"
  end
  factory :answer do
    body
    association :question

    trait :invalid do
      body { nil }
    end
  end
end
