# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    association :question

    trait :invalid do
      body { nil }
    end
  end
end
