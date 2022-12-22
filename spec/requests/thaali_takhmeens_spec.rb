require 'rails_helper'

RSpec.describe "ThaaliTakhmeens", type: :request do
  # * NEW
  context "GET new" do
    before do
      sabeel = FactoryBot.create(:sabeel)
      get new_sabeel_thaali_takhmeen_path, params: { id: sabeel.id }
    end

    it "should return a 200 (OK) status code" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it { should render_template(:new) }
  end
end
