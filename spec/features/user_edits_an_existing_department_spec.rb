require 'rails_helper'

feature 'User edits an existing department' do
  background do
    user = create(:user, :confirmed, :roles => 'admin')

    sign_in_with user.email, user.password

    company # Create the company before visiting new page

    visit edit_configuration_department_path(department)
  end
  given(:company) { create(:company) }
  given(:department) { create(:department, :company => create(:company)) }

  context 'when the details are valid' do
    scenario 'the user sees a success message' do
      fill_in :department_name, :with => Faker::Lorem.word
      select_by_value :department_company_id, company.id

      click_on 'Save'

      expect(page).to have_content(I18n.t('contacts.department.update.success'))
    end
  end

  context 'when the details are not valid' do
    scenario 'the user sees an error message' do
      select_by_value :department_company_id, nil

      click_on 'Save'

      expect(page).to have_content(/error/i)
    end
  end
end
