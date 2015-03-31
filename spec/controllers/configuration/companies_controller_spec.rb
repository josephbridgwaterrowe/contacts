require 'rails_helper'

RSpec.describe Configuration::CompaniesController, :type => :controller do
  before { sign_in(double(:user, :has_role? => true)) }

  describe 'GET edit' do
    let(:company) { double(:company, :id => 1) }
    before do
      allow(Company).to receive(:find) { company }

      get :edit, :id => company.id
    end

    context 'when the company exists' do
      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:edit) }
      it { expect(assigns(:company)).to be_present }
    end
  end

  describe 'GET index' do
    before do
      allow(Company).
        to receive_message_chain(:order, :to_a).and_return([Company.new])

      get :index
    end

    it { is_expected.to respond_with(200) }
    it { is_expected.to render_template(:index) }
    it { expect(assigns(:companies)).to be_kind_of(Array) }
    it { expect(assigns(:companies).first).to be_kind_of(Company) }
  end

  describe 'GET new' do
    before do
      get :new
    end

    it { is_expected.to respond_with(200) }
    it { is_expected.to render_template(:new) }
    it { expect(assigns(:company)).to be_present }
    it { expect(assigns(:company)).to be_kind_of(Company) }
  end

  describe 'GET show' do
    let(:company) { double(:company, :id => 1) }
    before do
      allow(Company).to receive(:find) { company }

      get :show, :id => company.id
    end

    context 'when the company exists' do
      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:show) }
      it { expect(assigns(:company)).to be_present }
    end
  end

  describe 'PATCH update' do
    before do
      allow(Company).to receive(:find).and_return(company)

      patch :update, :id => company.id
    end

    context 'when the company is valid' do
      let(:company) do
        double(:company, :id => 1, :update_attributes => true)
      end

      it { is_expected.to respond_with(302) }
      it { is_expected.to redirect_to(configuration_company_path(company.id)) }
    end

    context 'when the company is not valid' do
      let(:company) do
        double(:company, :id => 1, :update_attributes => false)
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'POST create' do
    before do
      allow(Company).to receive(:new).and_return(company)

      post :create, :company => {}
    end

    context 'when the company is valid' do
      let(:company) do
        double(:company, :id => 1, :save => true)
      end

      it { is_expected.to respond_with(302) }
      it { is_expected.to redirect_to(configuration_company_path(company.id)) }
      # rubocop:disable Metrics/LineLength
      it { is_expected.to set_flash[:notice].to(I18n.t('app.company.create.success')) }
      # rubocop:enable Metrics/LineLength
    end

    context 'when the company is not valid' do
      let(:company) do
        double(:company, :id => 1, :save => false)
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:new) }
    end
  end
end
