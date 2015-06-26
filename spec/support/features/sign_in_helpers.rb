module FeatureHelpers
  def sign_in_with(email, password)
    visit '/users/sign_in'
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_button 'Sign in'
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, :type => :feature
end
