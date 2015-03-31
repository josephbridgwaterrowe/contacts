require 'rails_helper'

RSpec.describe DepartmentsController, :type => :controller do
  render_views

  before { sign_in(double(:user, :has_role? => true)) }

  describe 'GET index' do
    let(:departments) do
      [
        Department.new(:id => 1, :name => Faker::Commerce.department),
        Department.new(:id => 2, :name => Faker::Commerce.department)
      ]
    end
    before do
      search_result = double(:search,
        :result => departments)
      allow(Department).
        to receive_message_chain(:order, :search).and_return(search_result)

      get :index, :format => :json
    end

    it { is_expected.to respond_with(200) }
    it { is_expected.to have_content_type('application/json') }
    its 'body is not empty' do
      expect(response.body).not_to be_empty
    end

    describe 'JSON.parse(response.body, ...' do
      let(:json) { JSON.parse(response.body, :symbolize_names => true) }

      describe 'json[0]' do
        subject { json[0] }

        it { is_expected.to be_kind_of(Hash) }
        its(:keys) { is_expected.to eq([:id, :name]) }
        its([:id]) { is_expected.to eq(departments[0].id) }
        its([:name]) { is_expected.to eq(departments[0].name) }
      end
    end
  end
end
