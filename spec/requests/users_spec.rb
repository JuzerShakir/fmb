# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User request" do
  # * Accessible by Admin & Member
  describe "'Admin' & 'Member' can access 👉" do
    let(:user) { create(:user_other_than_viewer) }

    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end

    # * SHOW
    describe "GET /show" do
      before do
        get user_path(user)
      end

      it "renders show template" do
        expect(response).to render_template(:show)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(user.its.to_s)
      end
    end

    # * EDIT
    describe "GET /edit" do
      before do
        get edit_user_path(user)
      end

      it "renders edit template" do
        expect(response).to render_template(:edit)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * UPDATE
    describe "PATCH /update" do
      context "with valid attributes" do
        let(:password) { attributes_for(:user)[:password] }

        before do
          hash_params = {password:, password_confirmation: password}
          patch user_path(user), params: {user: user.attributes.merge(hash_params)}
        end

        it "redirects to updated user" do
          expect(response).to redirect_to user
        end
      end

      context "with invalid attributes" do
        let(:password) { nil }

        before do
          hash_params = {password:, password_confirmation: password}
          patch user_path(user), params: {user: user.attributes.merge(hash_params)}
        end

        it "renders an edit template" do
          expect(response).to render_template(:edit)
        end
      end
    end

    # * DESTROY themselves
    describe "DELETE /destroy" do
      before do
        delete user_path(user)
      end

      it "destroys the user" do
        expect(User.find_by(id: user.id)).to be_nil
      end

      it "redirects to the login path" do
        expect(response).to redirect_to login_path
      end
    end
  end

  # * NOT ACCESSIBLE by viewer
  describe "'Viewer' CANNOT access 👉" do
    let(:viewer) { create(:viewer_user) }

    before do
      post signup_path, params: {sessions: viewer.attributes.merge({password: viewer.password})}
    end

    # * SHOW
    describe "GET /show" do
      before { get user_path(viewer) }

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * EDIT
    describe "GET /edit" do
      before { get edit_user_path(viewer) }

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * DESTROY
    describe "DELETE /destroy" do
      before do
        delete user_path(viewer)
      end

      it "destroys the user" do
        expect(User.find_by(id: viewer.id)).not_to be_nil
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  # * Accessible by ADMIN
  describe "'Admin' can access 👉" do
    let(:admin) { create(:admin_user) }
    let(:other_user) { create(:user) }

    before do
      post signup_path, params: {sessions: admin.attributes.merge({password: admin.password})}
    end

    # * NEW
    describe "GET /new" do
      before { get new_user_path }

      it "renders new template" do
        expect(response).to render_template(:new)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * CREATE
    describe "POST /create" do
      let(:user) { attributes_for(:user) }

      before do
        get new_user_path
      end

      context "with valid attributes" do
        before do
          post users_path, params: {user:}
        end

        it "redirects to index path of User" do
          expect(response).to redirect_to users_path
        end

        it "returns with 302 redirect status code" do
          expect(response).to have_http_status(:found)
        end
      end

      describe "with invalid attributes" do
        before do
          post users_path, params: {user: user.merge(its: nil)}
        end

        it "renders new template" do
          expect(response).to render_template(:new)
        end

        it "returns with 422 status code" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * SHOW page of other users
    describe "GET show of other user" do
      before do
        get user_path(other_user)
      end

      it "renders show template" do
        expect(response).to render_template(:show)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(other_user.its.to_s)
      end
    end

    # * INDEX
    describe "GET index" do
      before { get users_path }

      it "renders a index template with 200 status code" do
        expect(response).to render_template(:index)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * DESTROY other users
    describe "DELETE destroy" do
      before do
        delete user_path(other_user)
      end

      it "destroys the other user" do
        expect(User.find_by(id: other_user.id)).to be_nil
      end

      it "redirects to the login path" do
        expect(response).to redirect_to users_path
      end
    end
  end

  # * NOT ADMIN
  describe "NOT an 'admin', CANNOT access 👉" do
    let(:user) { create(:user_other_than_admin) }
    let(:other_user) { create(:user_other_than_admin) }

    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end

    # * NEW
    describe "GET new" do
      before { get new_user_path }

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * SHOW page of other users
    describe "GET show of other user" do
      before { get user_path(other_user) }

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * INDEX
    describe "GET index" do
      before { get users_path }

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
