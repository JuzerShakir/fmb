require 'rails_helper'

RSpec.describe "Sabeels", type: :request do
  valid_attributes = { its: 12345678, hof_name: "Juzer", apartment: "maimoon_b", flat_no: 101, mobile: 1234567890, email: nil }
  invalid_attributes = { its: nil, hof_name: "Juzer", apartment: nil, flat_no: nil, mobile: nil, email: nil}

  context "GET new" do
    before { get new_sabeel_path }

    it "should return an 200 (OK) status code" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it { should render_template(:new) }
  end

  context "POST create" do
    subject { build(:sabeel) }

    it "creates new sabeel" do
      expect {
        post sabeel_path, params: { sabeel: valid_attributes }
      }.to change { Sabeel.count }.from(0).to(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to sabeel_path
    end

    it "raises validation errors" do
      subject { build(:sabeel) }

      expect {
        post sabeel_path, params: { sabeel: invalid_attributes }
      }.to_not change { Sabeel.count }

      expect(response).to have_http_status(:ok)
      expect(subject).to render_template(:new)
    end
  end
end
