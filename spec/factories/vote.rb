FactoryBot.define do
  factory :vote do
    user
    value { 0 }
  end
end