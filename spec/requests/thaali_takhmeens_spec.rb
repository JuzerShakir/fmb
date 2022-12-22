require 'rails_helper'

RSpec.describe "ThaaliTakhmeens", type: :request do
  sabeel = FactoryBot.create(:sabeel)
  valid_attributes = { number: 1, size: "small", year: 2022, total: 10000, sabeel_id: sabeel.id }
  invalid_attributes = { number: nil, size: "medium", year: 2022, total: 20000, sabeel_id: sabeel.id }

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
  end
end
