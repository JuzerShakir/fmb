# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ThaaliTakhmeen request - user type 👉" do
  before do
    @password = Faker::Internet.password(min_length: 6, max_length: 72)
  end

  # * Accessible by all
  context "any user can access 👉" do
    before do
      @user = create(:user, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
    end

    # * INDEX
    context "GET index" do
      before do
        get root_path
      end

      it "renders an index template with 200 status code" do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end

    # * SHOW
    context "GET show" do
      before do
        @thaali = create(:thaali_takhmeen)
        get takhmeen_path(@thaali.id)
      end

      it "renders a show template" do
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only number
        expect(response.body).to include(@thaali.number.to_s)
      end
    end

    # * STATISTICS
    context "GET stats" do
      before do
        get takhmeens_stats_path
      end

      it "renders a stats template" do
        expect(response).to render_template(:stats)
        expect(response).to have_http_status(:ok)
      end
    end

    # * COMPLETE
    context "GET complete" do
      before do
        get thaali_takhmeens_complete_path(CURR_YR)
      end

      it "renders a complete template" do
        expect(response).to render_template(:complete)
        expect(response).to have_http_status(:ok)
      end
    end

    # * PENDING
    context "GET pending" do
      before do
        get thaali_takhmeens_pending_path(CURR_YR)
      end

      it "renders a pending template" do
        expect(response).to render_template(:pending)
        expect(response).to have_http_status(:ok)
      end
    end

    # * ALL
    context "GET all" do
      before do
        get thaali_takhmeens_all_path(PREV_YR)
      end

      it "renders a all template" do
        expect(response).to render_template(:all)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # * Accessible by Admins & Members
  context "'admin' & 'member' can access 👉" do
    before do
      @user = create(:user_other_than_viewer, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
    end

    # * NEW
    context "GET new" do
      before do
        @sabeel = create(:sabeel)
      end

      context "if sabeel HAS NOT registered for currrent-year thaali" do
        it "RENDERS a new template with 200 status code" do
          get new_sabeel_takhmeen_path(@sabeel)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:new)
        end

        context "and if sabeel has taken previous year thaali" do
          before do
            @prev_thaali = create(:previous_takhmeen, sabeel_id: @sabeel.id)
            get new_sabeel_takhmeen_path(@sabeel)
          end

          it "shows 'number' & 'size' attribute values in the form" do
            expect(response.body).to include(@prev_thaali.number.to_s)
            expect(response.body).to include(@prev_thaali.size)
          end
        end
      end

      context "if sabeel HAS registered for currrent-year thaali" do
        before do
          @cur_thaali = create(:active_takhmeen, sabeel_id: @sabeel.id)
        end

        it "DOES NOT render new tempelate" do
          get new_sabeel_takhmeen_path(@sabeel)
          expect(response).to redirect_to sabeel_path(@sabeel)
        end
      end
    end

    # * CREATE
    context "POST create" do
      before do
        @sabeel = create(:sabeel)
      end

      context "with valid attributes" do
        before do
          @valid_attributes = attributes_for(:thaali_takhmeen)
          post sabeel_takhmeens_path(sabeel_id: @sabeel.id), params: {thaali_takhmeen: @valid_attributes}
          @thaali = @sabeel.thaali_takhmeens.first
        end

        it "creates a new Thaali" do
          expect(@thaali).to be_truthy
        end

        it "redirects to created thaali" do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to takhmeen_path(@thaali)
        end
      end

      context "with invalid attributes" do
        before do
          @invalid_attributes = attributes_for(:thaali_takhmeen, size: nil)
          post sabeel_takhmeens_path(sabeel_id: @sabeel.id), params: {thaali_takhmeen: @invalid_attributes}
          @thaali = @sabeel.thaali_takhmeens.first
        end

        it "does not create a new Thaali" do
          expect(@thaali).to be_nil
        end

        it "renders a new template" do
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * EDIT
    context "GET edit" do
      before do
        @thaali = create(:thaali_takhmeen)
        get edit_takhmeen_path(@thaali.id)
      end

      it "renders render an edit template" do
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only size
        expect(response.body).to include(@thaali.size)
      end
    end

    # * UPDATE
    context "PATCH update" do
      before do
        @thaali = create(:thaali_takhmeen)
      end

      context "with valid attributes" do
        before do
          @thaali.number = Random.rand(1..100)
          patch takhmeen_path(@thaali), params: {thaali_takhmeen: @thaali.attributes}
        end

        it "redirects to updated thaali page" do
          expect(response).to redirect_to takhmeen_path("#{@thaali.year}-#{@thaali.number}")
        end
      end

      context "with invalid attributes" do
        before do
          @thaali.total = 0
          patch takhmeen_path(@thaali), params: {thaali_takhmeen: @thaali.attributes}
        end

        it "renders an edit template" do
          expect(response).to render_template(:edit)
        end
      end
    end

    # * DESTROY
    context "DELETE destroy" do
      before do
        @sabeel = create(:sabeel)
        thaali = create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        delete takhmeen_path(thaali)
        # find method will raise an error
        @thaali = ThaaliTakhmeen.find_by(id: thaali.id)
      end

      it "destroys the thaali" do
        expect(@thaali).to be_nil
      end

      it "redirects to its sabeel page" do
        expect(response).to redirect_to sabeel_path(@sabeel)
      end
    end
  end

  # * NOT Accessible by Viewers
  context "'viewer' CANNOT access 👉" do
    before do
      @viewer = create(:viewer_user, password: @password)
      post signup_path, params: {sessions: @viewer.attributes.merge({password: @password})}
      @sabeel = create(:sabeel)
    end

    # * NEW
    context "GET new" do
      before do
        get new_sabeel_takhmeen_path(@sabeel)
      end

      it "does not render a new template" do
        expect(response).not_to render_template(:new)
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * EDIT
    context "GET edit" do
      before do
        @thaali = create(:thaali_takhmeen)
        get edit_takhmeen_path(@thaali)
      end

      it "does not render a edit template" do
        expect(response).not_to render_template(:edit)
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * DETROY
    context "DELETE destroy" do
      before do
        thaali = create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        delete takhmeen_path(thaali)
        # find method will raise an error
        @thaali = ThaaliTakhmeen.find_by(id: thaali.id)
      end

      it "does not destroy the thaali" do
        expect(@thaali).not_to be_nil
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
