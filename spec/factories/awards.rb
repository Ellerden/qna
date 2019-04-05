FactoryBot.define do
  factory :award do
    sequence :name do |n|
      "MyAward#{n}"
    end
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/images/badge.png", 'image/png') }
  end
end
