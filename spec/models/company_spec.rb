require 'rails_helper'

RSpec.describe Company, :type => :model do
  let(:company) { create(:company) }

  it { is_expected.to have_many(:departments) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe '#to_s' do
    subject { company.to_s }

    it { is_expected.to eq(company.name) }
  end
end
