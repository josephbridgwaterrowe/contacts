require 'rails_helper'

RSpec.describe CreateContact, :type => :interactor do
  let!(:address_book) { create(:address_book) }
  let(:contact_entry) do
    build(:contact_entry,
          :company_id => department.company.id,
          :department_id => department.id,
          :display_name => display_name,
          :first_name => first_name,
          :last_name => last_name)
  end
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:display_name) { "#{first_name} #{last_name}" }
  let(:department) { create(:department) }
  let(:user) { create(:user) }
  subject(:context) do
    CreateContact.call(
      contact_entry.to_h.merge(:user_id => user.id))
  end

  context 'when the parameters are valid' do
    describe Interactor::Context do
      it { is_expected.to be_a_success }
      its(:message) do
        is_expected.to eq(I18n.t('contacts.contact.create.success'))
      end
      its(:contact) { is_expected.to be_present }

      describe '#contact' do
        subject { context.contact }

        its(:present?) { is_expected.to be true }
        its(:persisted?) { is_expected.to be true }
        its(:errors) { is_expected.to be_empty }
        its(:company) { is_expected.to eq(department.company) }
        its(:department) { is_expected.to eq(department) }
        its(:display_name) { is_expected.to eq(contact_entry.display_name) }
        its(:first_name) { is_expected.to eq(contact_entry.first_name) }
        its(:last_name) { is_expected.to eq(contact_entry.last_name) }
      end
    end
  end

  context 'when the parameters are not valid' do
    let(:display_name) { nil }

    describe Interactor::Context do
      it { is_expected.to be_a_failure }
      its(:message) do
        is_expected.to eq(I18n.t('contacts.contact.create.invalid'))
      end
      its(:contact) { is_expected.to be_present }

      describe '#contact' do
        subject { context.contact }

        its(:present?) { is_expected.to be true }
        its(:persisted?) { is_expected.to be false }
      end
    end
  end
end
