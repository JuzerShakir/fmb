require 'rails_helper'

RSpec.describe "Sabeels", type: :request do

  context "GET new" do
    before { get new_sabeel_path }

    it "should return an 200 (OK) status code" do
      expect(response).to have_http_status(:ok)
    end

    it { should render_template(:new) }
  end

  context "POST create" do
    subject { build(:sabeel) }

    it "creates new sabeel" do
      expect {
        post sabeel_path, params: {
          sabeel: {
            its: subject.its,
            hof_name: subject.hof_name,
            apartment: subject.apartment,
            flat_no: subject.flat_no,
            mobile: subject.mobile,
            email: nil
          }
        }
      }.to change { Sabeel.count }.from(0).to(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to sabeel_path
    end

    it "raises validation errors" do
      subject { build(:sabeel) }

      expect {
        post sabeel_path, params: {
          sabeel: {
            hof_name: subject.hof_name,
            apartment: subject.apartment,
            flat_no: subject.flat_no,
            mobile: subject.mobile,
          }
        }
      }.to_not change { Sabeel.count }

      expect(response).to have_http_status(:ok)
      expect(subject).to render_template(:new)
    end
  end
end
