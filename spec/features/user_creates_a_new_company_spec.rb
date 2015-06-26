require 'rails_helper'

feature 'User creates a new company' do
  background do
    user = create(:user, :confirmed, :roles => 'admin')

    sign_in_with user.email, user.password

    visit new_configuration_company_path
  end

  context 'when the details are valid' do
    scenario 'the user sees a success message' do
      fill_in :company_name, :with => Faker::Lorem.word

      click_on 'Save'

      expect(page).to have_content(I18n.t('contacts.company.create.success'))
    end
  end

  context 'when the details are not valid' do
    scenario 'the user sees an error message' do
      click_on 'Save'

      expect(page).to have_content(/error/i)
    end
  end
end
