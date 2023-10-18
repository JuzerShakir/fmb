# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User request - user type 👉" do
  before do
    @password = Faker::Internet.password(min_length: 6, max_length: 72)
  end

  # * Accessible by Admin & Member
  context "'Admin' & 'Member' can access 👉" do
    before do
      @user = create(:user_other_than_viewer, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
    end

    # * SHOW
    context "GET show" do
      before do
        get user_path(@user)
      end

      it "renders a show template" do
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(@user.its.to_s)
      end
    end

    # * EDIT
    context "GET edit" do
      before do
        get edit_user_path(@user)
      end

      it "renders render an edit template" do
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:ok)
      end
    end

    # * UPDATE
    context "PATCH update" do
      context "with valid attributes" do
        it "redirects to updated user" do
          new_password = Faker::Internet.password(min_length: 6, max_length: 72)
          password = new_password
          password_confirmation = new_password

          hash_params = {password: password, password_confirmation: password_confirmation}
          user_params = @user.attributes.merge(hash_params)

          patch user_path(@user), params: {user: user_params}

          expect(response).to redirect_to @user
        end
      end

      context "with invalid attributes" do
        it "renders an edit template" do
          password = nil
          password_confirmation = nil

          hash_params = {password: password, password_confirmation: password_confirmation}
          user_params = @user.attributes.merge(hash_params)

          patch user_path(@user), params: {user: user_params}

          expect(response).to render_template(:edit)
        end
      end
    end

    # * DESTROY themselves
    context "DELETE destroy" do
      before do
        delete user_path(@user)
        @user = User.find_by(id: @user.id)
      end

      it "destroys the user" do
        expect(@user).to be_nil
      end

      it "redirects to the login path" do
        expect(response).to redirect_to login_path
      end
    end
  end

  # * NOT ACCESSIBLE by viewer
  context "'Viewer' CANNOT access 👉" do
    before do
      @viewer = create(:viewer_user, password: @password)
      post signup_path, params: {sessions: @viewer.attributes.merge({password: @password})}
    end

    # * SHOW
    context "GET show" do
      before { get user_path(@viewer) }

      it "does not render the 'show' template" do
        expect(response).not_to render_template(:show)
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
      before { get edit_user_path(@viewer) }

      it "does not render the 'edit' template" do
        expect(response).not_to render_template(:edit)
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * DESTROY
    context "DELETE destroy" do
      before do
        delete user_path(@viewer)
        @viewer = User.find_by(id: @viewer.id)
      end

      it "destroys the user" do
        expect(@viewer).not_to be_nil
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  # * Accessible by ADMIN
  context "'Admin' can access 👉" do
    before do
      @admin = create(:admin_user, password: @password)
      post signup_path, params: {sessions: @admin.attributes.merge({password: @password})}
      @user = create(:user, password: @password)
    end

    # * NEW
    context "GET new" do
      before { get new_user_path }

      it "renders a new template with 200 status code" do
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end

    # * CREATE
    context "POST create" do
      before do
        get new_user_path
        @valid = attributes_for(:user)
        @invalid = attributes_for(:invalid_user)
      end

      context "with valid attributes" do
        before do
          post users_path, params: {user: @valid}
          @user = User.find_by(its: @valid[:its])
        end

        it "creates a new User" do
          expect(@user).to be_truthy
        end

        it "redirects to index path of User" do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to users_path
        end
      end

      context "with invalid attributes" do
        before do
          post users_path, params: {user: @invalid}
          @invalid_user = User.find_by(its: @invalid[:its])
        end

        it "does not create a new User" do
          expect(@invalid_user).to be_nil
        end

        it "renders a new template" do
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * SHOW page of other users
    context "GET show of other user" do
      before do
        get user_path(@user)
      end

      it "renders a show template" do
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(@user.its.to_s)
      end
    end

    # * INDEX
    context "GET index" do
      before { get users_path }

      it "renders a index template with 200 status code" do
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end
    end

    # * DESTROY other users
    context "DELETE destroy" do
      before do
        delete user_path(@user)
        @user = User.find_by(id: @user.id)
      end

      it "destroys the other user" do
        expect(@user).to be_nil
      end

      it "redirects to the login path" do
        expect(response).to redirect_to users_path
      end
    end
  end

  # * NOT ADMIN
  context "NOT an 'admin', CANNOT access 👉" do
    before do
      @user = create(:user_other_than_admin, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
      @other_user = create(:user_other_than_admin, password: @password)
    end

    # * NEW
    context "GET new" do
      before { get new_user_path }

      it "does not render the 'new' template" do
        expect(response).not_to render_template(:new)
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * SHOW page of other users
    context "GET show of other user" do
      before { get user_path(@other_user) }

      it "does not render the 'show' template" do
        expect(response).not_to render_template(:show)
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * INDEX
    context "GET index" do
      before { get users_path }

      it "does not render the 'index' template" do
        expect(response).not_to render_template(:index)
      end

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
