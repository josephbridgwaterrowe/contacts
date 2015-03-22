require 'rails_helper'

RSpec.describe Department, :type => :model do
  let(:department) { create(:department) }

  it { is_expected.to belong_to(:company) }
  it { is_expected.to validate_presence_of(:company) }
  it { is_expected.to validate_presence_of(:name) }

  describe '#to_s' do
    subject { department.to_s }

    it { is_expected.to eq(department.name) }
  end
end
