# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    association :question
    association :author

    trait :invalid do
      body { nil }
    end
  end
end
