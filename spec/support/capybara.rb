require 'capybara/rails'

def select_by_value(id, value)
  option_xpath = "//*[@id='#{id}']/option[@value='#{value}']"
  option = find(:xpath, option_xpath).text
  select(option, :from => id)
end
