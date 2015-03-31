require 'rails_helper'

RSpec.describe Contact, :type => :model do
  it { is_expected.to belong_to(:address_book) }
  it { is_expected.to belong_to(:company) }
  it { is_expected.to belong_to(:department) }
  it { is_expected.to belong_to(:manager) }
  it { is_expected.to validate_presence_of(:display_name) }
end
