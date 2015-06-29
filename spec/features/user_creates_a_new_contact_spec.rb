require 'rails_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

feature 'User creates a new contact', :js => true do
  background do
    sign_in_with user.email, user.password
  end
  given!(:address_book) { create(:address_book) }
  given!(:department) { create(:department) }
  given(:first_name) { Faker::Name.first_name }
  given(:last_name) { Faker::Name.last_name }
  given(:user) { create(:user, :confirmed, :roles => 'admin') }

  context 'when the details are valid' do
    scenario 'the user sees a success message' do
      visit new_configuration_contact_path

      fill_in :contact_entry_display_name, :with => "#{first_name} #{last_name}"
      fill_in :contact_entry_first_name, :with => first_name
      fill_in :contact_entry_last_name, :with => last_name
      fill_in :contact_entry_email_address, :with => Faker::Internet.email
      fill_in :contact_entry_phone_number,
              :with => Faker::PhoneNumber.phone_number
      fill_in :contact_entry_street_address, :with => Faker::Address.street_name
      fill_in :contact_entry_city, :with => Faker::Address.city
      fill_in :contact_entry_region, :with => Faker::Address.state
      fill_in :contact_entry_postal_code, :with => Faker::Address.zip_code
      select department.company.to_s, :from => :contact_entry_company_id
      select department.to_s, :from => :contact_entry_department_id

      click_on 'Save'

      expect(page).to have_content(I18n.t('contacts.contact.create.success'))
    end
  end

  context 'when the details are not valid' do
    scenario 'the user sees an error message' do
      visit new_configuration_contact_path

      click_on 'Save'

      expect(page).to have_content(/error/i)
    end
  end
end
