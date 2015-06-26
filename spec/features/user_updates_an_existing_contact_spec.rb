require 'rails_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

feature 'User updates an existing contact', :js => true do
  background do
    sign_in_with user.email, user.password
  end
  given!(:contact) { create(:contact) }
  given!(:department) { create(:department) }
  given(:user) { create(:user, :confirmed, :roles => 'admin') }

  context 'when the details are valid' do
    scenario 'the user sees a success message' do
      visit edit_configuration_contact_path(contact)

      select department.company.to_s, :from => :contact_entry_company_id
      select department.to_s, :from => :contact_entry_department_id

      click_on 'Save'

      expect(page).to have_content(I18n.t('contacts.contact.update.success'))

      contact.reload
      expect(contact.company).to eq(department.company)
      expect(contact.department).to eq(department)
    end
  end

  context 'when the details are not valid' do
    scenario 'the user sees an error message' do
      visit edit_configuration_contact_path(contact)

      fill_in :contact_entry_display_name, :with => nil

      click_on 'Save'

      expect(page).to have_content('error')
    end
  end
end
