FactoryBot.define do
  factory :authorization do
    association :user
    provider { "MyString" }
    uid { "MyString" }
    linked_email { 'test@test.ru' }
    confirmed_at { Time.now.utc }
  end
end
