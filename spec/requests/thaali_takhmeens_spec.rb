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
    sabeel.destroy
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

      let!(:thaali) { ThaaliTakhmeen.find_by(number: valid_attributes[:number]) }

      it "should create a new Thaali" do
        expect(thaali).to be_truthy
      end

      it "should redirect to created thaali" do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to sabeel_thaali_takhmeen_path(id: thaali.id)
      end
    end

    context "with invalid attributes" do
      before do
        post sabeel_thaali_takhmeens_path, params: { thaali_takhmeen: invalid_attributes }
      end

      let!(:thaali) { ThaaliTakhmeen.find_by(number: invalid_attributes[:number]) }

      it "does not create a new Thaali" do
        expect(thaali).to be_nil
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
      thaali = ThaaliTakhmeen.create(valid_attributes)
      get sabeel_thaali_takhmeen_path(id: thaali.id)
    end

    it "should render a show template" do
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end

    it "should render the instance that was passed in the params" do
      # it could be any attribute, not only number
      expect(response.body).to include("#{valid_attributes.fetch(:number)}")
    end
  end

  # * EDIT
  context "GET edit" do
    before do
      thaali = ThaaliTakhmeen.create(valid_attributes)
      get edit_sabeel_thaali_takhmeen_path(id: thaali.id)
    end

    it "should render render an edit template" do
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:ok)
    end

    it "should render the instance that was passed in the params" do
      # it could be any attribute, not only size
      expect(response.body).to include("#{valid_attributes.fetch(:size)}")
    end
  end

  context "PATCH update" do
    context "valid attributes" do
      before do
        thaali = ThaaliTakhmeen.create(valid_attributes)
        valid_attributes[:number] = Random.rand(1..100)
        patch sabeel_thaali_takhmeen_path(id: thaali.id), params: { thaali_takhmeen: valid_attributes }
      end

      let!(:thaali) { ThaaliTakhmeen.find_by(number: valid_attributes[:number]) }

      it "should redirect to updated thaali page" do
        expect(response).to redirect_to sabeel_thaali_takhmeen_path
      end
    end

    context "with invalid attributes" do
      before do
        thaali = ThaaliTakhmeen.create(valid_attributes)
        patch sabeel_thaali_takhmeen_path(id: thaali.id), params: { thaali_takhmeen: invalid_attributes }
      end

      it "should render an edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end

    # * DESTROY
    context "DELETE destroy" do
      before do
        thaali = ThaaliTakhmeen.create(valid_attributes)
        delete sabeel_thaali_takhmeen_path(id: thaali.id)
      end

      let!(:thaali) { ThaaliTakhmeen.find_by(number: valid_attributes[:number]) }

      it "should destroy the sabeel" do
        expect(thaali).to be_nil
      end

      it "should redirect to its sabeel page" do
        expect(response).to redirect_to sabeel_path
      end
    end
end
