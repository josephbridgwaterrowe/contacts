FactoryGirl.define do
  factory :company do
    name { Faker::Lorem.word }
  end
end
