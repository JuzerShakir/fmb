require 'rails_helper'

RSpec.describe "Sabeels", type: :request do
  valid_attributes = { its: 12345678, hof_name: "Juzer", apartment: "maimoon_b", flat_no: 101, mobile: 1234567890, email: nil }
  invalid_attributes = { its: nil, hof_name: "Juzer", apartment: nil, flat_no: nil, mobile: nil, email: nil}

  before(:all) do
    Sabeel.destroy_all
  end

  # * NEW
  context "GET new" do
    before { get new_sabeel_path }

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
        post sabeel_path, params: { sabeel: valid_attributes }
      end

      it "should create a new Sabeel" do
        expect(Sabeel.count).to eq 1
      end

      it "should redirect to created sabeel" do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to sabeel_path
      end
    end

    context "with invalid attributes" do
      before do
        post sabeel_path, params: { sabeel: invalid_attributes }
      end

      it "does not create a new Sabeel" do
        expect(Sabeel.count).to eq 0
      end

      it "should render a new template" do
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

  # * EDIT
  context "GET edit" do
    before do
      sabeel = Sabeel.create(valid_attributes)
      get edit_sabeel_path(id: sabeel.id)
    end

    it "should render render an edit template" do
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:ok)
    end

    it "should render the apartment of the sabeel" do
      expect(response.body).to include("#{valid_attributes.fetch(:apartment)}")
    end
  end

  # * UPDATE
  context "PATCH update" do
    context "with valid attributes" do
      before do
        sabeel = Sabeel.create(valid_attributes)
        valid_attributes[:apartment] = "mohammedi"
        patch sabeel_path(id: sabeel.id), params: { sabeel: valid_attributes }
      end

      it "should redirect to updated sabeel" do
        expect(response).to redirect_to sabeel_path
      end

      it "should show the updated value" do
        get sabeel_path(id: Sabeel.last.id)
        expect(response.body).to include("mohammedi")
      end
    end

    context "with invalid attributes" do
      before do
        sabeel = Sabeel.create(valid_attributes)
        patch sabeel_path(id: sabeel.id), params: { sabeel: invalid_attributes }
      end

      it "should render an edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end

  # * DESTROY
  context "DELETE destroy" do
    before do
      sabeel = Sabeel.create(valid_attributes)
      delete sabeel_path(id: sabeel.id)
    end
    it "should destroy the sabeel" do
      expect(Sabeel.count).to eq 0
    end

    it "should redirect to the homepage"
  end
end
