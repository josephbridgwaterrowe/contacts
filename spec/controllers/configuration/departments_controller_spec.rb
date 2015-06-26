require 'rails_helper'

RSpec.describe Configuration::DepartmentsController, :type => :controller do
  before { sign_in(double(:user, :has_role? => true)) }

  describe 'GET edit' do
    let(:department) { double(:department, :id => 1) }
    before do
      allow(Department).to receive(:find) { department }
      allow(Company).
        to receive_message_chain(:order, :to_a).and_return([Company.new])

      get :edit, :id => department.id
    end

    context 'when the department exists' do
      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:edit) }
      it { expect(assigns(:companies)).to be_kind_of(Array) }
      it { expect(assigns(:department)).to be_present }
    end
  end

  describe 'GET index' do
    before do
      allow(Department).
        to receive_message_chain(:order, :to_a).and_return([Department.new])

      get :index
    end

    it { is_expected.to respond_with(200) }
    it { is_expected.to render_template(:index) }
    it { expect(assigns(:departments)).to be_kind_of(Array) }
    it { expect(assigns(:departments).first).to be_kind_of(Department) }
  end

  describe 'GET new' do
    before do
      get :new
    end

    it { is_expected.to respond_with(200) }
    it { is_expected.to render_template(:new) }
    it { expect(assigns(:companies)).to be_kind_of(Array) }
    it { expect(assigns(:department)).to be_present }
    it { expect(assigns(:department)).to be_kind_of(Department) }
  end

  describe 'GET show' do
    let(:department) { double(:department, :id => 1) }
    before do
      allow(Department).to receive(:find) { department }

      get :show, :id => department.id
    end

    context 'when the department exists' do
      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:show) }
      it { expect(assigns(:department)).to be_present }
    end
  end

  describe 'PATCH update' do
    before do
      allow(Department).to receive(:find).and_return(department)

      patch :update, :id => department.id
    end

    context 'when the department is valid' do
      let(:department) do
        double(:department, :id => 1, :update_attributes => true)
      end

      it { is_expected.to respond_with(302) }
      it { is_expected.to redirect_to(configuration_department_path(department.id)) }
    end

    context 'when the department is not valid' do
      let(:department) do
        double(:department, :id => 1, :update_attributes => false)
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'POST create' do
    before do
      allow(Department).to receive(:new).and_return(department)

      post :create, :department => {}
    end

    context 'when the department is valid' do
      let(:department) do
        double(:department, :id => 1, :save => true)
      end

      it { is_expected.to respond_with(302) }
      it { is_expected.to redirect_to(configuration_department_path(department.id)) }
      # rubocop:disable Metrics/LineLength
      it { is_expected.to set_flash[:notice].to(I18n.t('contacts.department.create.success')) }
      # rubocop:enable Metrics/LineLength
    end

    context 'when the department is not valid' do
      let(:department) do
        double(:department, :id => 1, :save => false)
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:new) }
    end
  end
end
