FactoryGirl.define do
  factory :contact_entry do
    contact_type { ContactEntry.new.contact_types.sample }
    display_name { "#{first_name} #{last_name}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    is_active 1
  end
end
