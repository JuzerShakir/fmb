require 'rails_helper'

RSpec.describe "Sabeels", type: :request do
  valid_attributes = { its: 12345678, hof_name: "Juzer", apartment: "maimoon_b", flat_no: 101, mobile: 1234567890, email: nil }
  invalid_attributes = { its: nil, hof_name: "Juzer", apartment: nil, flat_no: nil, mobile: nil, email: nil}

  # * NEW
  context "GET new" do
    before { get new_sabeel_path }

    it "should return an 200 (OK) status code" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it { should render_template(:new) }
  end

  # * CREATE
  context "POST create" do
    context "with valid attributes" do
      it "creates a new Sabeel" do
        expect {
          post sabeel_path, params: { sabeel: valid_attributes }
        }.to change { Sabeel.count }.by 1
        expect(response).to have_http_status(:found)
      end

      it "redirects to created sabeel" do
        post sabeel_path, params: { sabeel: valid_attributes }
        expect(response).to redirect_to sabeel_path
      end
    end

    context "with invalid attributes" do
      it "does not create a new Sabeel" do
        expect {
          post sabeel_path, params: { sabeel: invalid_attributes }
        }.to_not change { Sabeel.count }
      end

      it "renders a new template" do
        post sabeel_path, params: { sabeel: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # * SHOW
  context "GET show" do
    before do
      sabeel = Sabeel.create(valid_attributes)
      get sabeel_path(id: sabeel.id)
    end

    it "should render a show template" do
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end
    it "should render the ITS of the sabeel" do
      expect(response.body).to include("#{valid_attributes.fetch(:its)}")
    end
  end
end
