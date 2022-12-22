require 'rails_helper'

RSpec.describe "ThaaliTakhmeens", type: :request do
  sabeel = FactoryBot.create(:sabeel)
  valid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, sabeel_id: sabeel.id)
  invalid_attributes = FactoryBot.attributes_for(:thaali_takhmeen, size: nil, sabeel_id: sabeel.id)

  # destroys thaalis before running each context
  before(:all) do
    ThaaliTakhmeen.destroy_all
  end

  # destroys sabeel instance after all test suites have finished
  after(:all) do
    Sabeel.destroy_all
  end

  # * NEW
  context "GET new" do
    before do
      get new_sabeel_thaali_takhmeen_path, params: { id: sabeel.id }
    end

    it "should return a 200 (OK) status code" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it { should render_template(:new) }
  end

# * CREATE
  context "POST create" do
    context "with valid attributes" do
      before do
        post sabeel_thaali_takhmeens_path, params: { thaali_takhmeen: valid_attributes }
      end

      it "should create a new Thaali" do
        expect(ThaaliTakhmeen.count).to eq 1
      end

      it "should redirect to created thaali" do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to sabeel_thaali_takhmeen_path(id: ThaaliTakhmeen.last.id)
      end
    end

    context "with invalid attributes" do
      before do
        post sabeel_thaali_takhmeens_path, params: { thaali_takhmeen: invalid_attributes }
      end

      it "does not create a new Thaali" do
        expect(ThaaliTakhmeen.count).to eq 0
      end

      it "should render a new template" do
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
