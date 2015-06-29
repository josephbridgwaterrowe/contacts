require 'rails_helper'

RSpec.describe ContactEntry, :type => :model do
  subject do
    ContactEntry.new
  end

  it { is_expected.to validate_presence_of(:company_id) }
  it { is_expected.to validate_presence_of(:department_id) }
end
