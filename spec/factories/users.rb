FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    name { "#{first_name} #{last_name}" }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :confirmed do
      confirmed_at Time.now
    end
  end
end
