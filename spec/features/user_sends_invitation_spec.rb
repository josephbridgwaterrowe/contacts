require 'rails_helper'

feature 'User sends invitation' do
  background do
    user = create(:user, :confirmed, :roles => 'admin')

    sign_in_with user.email, user.password

    visit new_user_invitation_path
  end

  context 'when the details are valid' do
    scenario 'the user sees a success message' do
      email = Faker::Internet.email
      fill_in :user_email, :with => email
      fill_in :user_first_name, :with => Faker::Name.first_name
      fill_in :user_last_name, :with => Faker::Name.last_name

      click_on 'Send an invitation'

      expect(page).to have_content(
        I18n.t('devise.invitations.send_instructions', :email => email))
    end
  end

  context 'when the details are not valid' do
    scenario 'the user sees an error message' do
      click_on 'Send an invitation'

      expect(page).to have_content(/error/i)
    end
  end
end
