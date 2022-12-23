require 'rails_helper'

RSpec.describe "Sabeels", type: :request do
  valid_attributes =  FactoryBot.attributes_for(:sabeel)
  invalid_attributes = FactoryBot.attributes_for(:sabeel, its: nil)

  before(:all) do
    recent_sabeel = Sabeel.last
    recent_sabeel.destroy unless recent_sabeel.nil?
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
        sabeel = Sabeel.find_by(its: valid_attributes[:its])
        expect(sabeel).to be_truthy
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
        invalid_sabeel = Sabeel.find_by(its: invalid_attributes[:its])
        expect(invalid_sabeel).to be_nil
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
      3.times do |i|
        FactoryBot.create(:thaali_takhmeen, sabeel_id: sabeel.id, year: i)
      end
      get sabeel_path(id: sabeel.id)
    end

    it "should render a show template" do
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end

    it "should render the instance that was passed in the params" do
      # it could be any attribute, not only ITS
      expect(response.body).to include("#{valid_attributes.fetch(:its)}")
    end

    it "total count of takhmeens of a sabeel" do
      expect(response.body).to include("Total Takhmeens 3")
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

    it "should render the instance that was passed in the params" do
      # it could be any attribute, not only apartment
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
        sabeel = Sabeel.find_by(its: valid_attributes[:its])
        get sabeel_path(id: sabeel.id)
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

    let!(:sabeel) { Sabeel.find_by(its: valid_attributes[:its]) }

    it "should destroy the sabeel" do
      expect(sabeel).to be_nil
    end

    it "should redirect to the homepage"
  end
end
