require 'rails_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

feature 'User edits an existing contact', :js => true do
  background do
    user = create(:user, :confirmed, :roles => 'admin')

    sign_in_with user.email, user.password

    # company # Create the company before visiting new page
    department # Create the company before visiting new page

    visit edit_configuration_contact_path(contact)
  end
  given(:contact) { create(:contact) }
  given(:department) { create(:department) }

  context 'when the details are valid' do
    scenario 'the user sees a success message' do
      select_by_value :contact_company_id, department.company.id
      select_by_value :contact_department_id, department.id

      click_on 'Save'

      expect(page).to have_content(I18n.t('app.contact.update.success'))

      contact.reload
      expect(contact.company).to eq(department.company)
      expect(contact.department).to eq(department)
    end
  end

  context 'when the details are not valid' do
    scenario 'the user sees an error message' do
      fill_in :contact_display_name, :with => nil

      click_on 'Save'

      expect(page).to have_content(/error/i)
    end
  end
end
