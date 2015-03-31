FactoryGirl.define do
  factory :department do
    company
    name { Faker::Lorem.word }
  end
end
