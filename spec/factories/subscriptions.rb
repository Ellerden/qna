FactoryBot.define do
  factory :subscription do
    association :question
    association :author, factory: :user
  end
end
