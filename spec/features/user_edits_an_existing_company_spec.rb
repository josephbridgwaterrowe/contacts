require 'rails_helper'

feature 'User edits an existing company' do
  background do
    user = create(:user, :confirmed, :roles => 'admin')

    sign_in_with user.email, user.password

    visit edit_configuration_company_path(company)
  end
  given(:company) { create(:company) }

  context 'when the details are valid' do
    scenario 'the user sees a success message' do
      fill_in :company_name, :with => Faker::Lorem.word

      click_on 'Save'

      expect(page).to have_content(I18n.t('app.company.update.success'))
    end
  end

  context 'when the details are not valid' do
    scenario 'the user sees an error message' do
      fill_in :company_name, :with => nil

      click_on 'Save'

      expect(page).to have_content(/error/i)
    end
  end
end
