FactoryGirl.define do
  factory :contact do
    address_book
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    display_name { "#{first_name} #{last_name}" }
    email_address { Faker::Internet.email }
  end
end
