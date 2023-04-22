require "rails_helper"

RSpec.describe "User request - user type 👉", type: :request do
  before do
    @password = Faker::Internet.password(min_length: 6, max_length: 72)
  end

  # * Accessible by Admin & Member
  context "'Admin' & 'Member' can access 👉" do
    before do
      @user = FactoryBot.create(:user_other_than_viewer, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
    end

    # * SHOW
    context "GET show" do
      before do
        get user_path(@user)
      end

      scenario "should render a show template" do
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      scenario "should render the instance that was passed in the params" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(@user.its.to_s)
      end
    end

    # * EDIT
    context "GET edit" do
      before do
        get edit_user_path(@user)
      end

      it "should render render an edit template" do
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:ok)
      end
    end

    # * UPDATE
    context "PATCH update" do
      context "with valid attributes" do
        scenario "should redirect to updated user" do
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
        scenario "should render an edit template" do
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

      scenario "should destroy the user" do
        expect(@user).to be_nil
      end

      scenario "should redirect to the login path" do
        expect(response).to redirect_to login_path
      end
    end
  end

  # * NOT ACCESSIBLE by viewer
  context "'Viewer' CANNOT access 👉" do
    before do
      @viewer = FactoryBot.create(:viewer_user, password: @password)
      post signup_path, params: {sessions: @viewer.attributes.merge({password: @password})}
    end

    # * SHOW
    context "GET show" do
      before { get user_path(@viewer) }

      scenario "should NOT render the 'show' template" do
        expect(response).not_to render_template(:show)
      end

      scenario "should respond with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      scenario "should redirect to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * EDIT
    context "GET edit" do
      before { get edit_user_path(@viewer) }

      scenario "should NOT render the 'edit' template" do
        expect(response).not_to render_template(:edit)
      end

      scenario "should respond with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      scenario "should redirect to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * DESTROY
    context "DELETE destroy" do
      before do
        delete user_path(@viewer)
        @viewer = User.find_by(id: @viewer.id)
      end

      scenario "should destroy the user" do
        expect(@viewer).to_not be_nil
      end

      scenario "should redirect to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  # * Accessible by ADMIN
  context "'Admin' can access 👉" do
    before do
      @admin = FactoryBot.create(:admin_user, password: @password)
      post signup_path, params: {sessions: @admin.attributes.merge({password: @password})}
      @user = FactoryBot.create(:user, password: @password)
    end

    # * NEW
    context "GET new" do
      before { get new_user_path }

      scenario "should render a new template with 200 status code" do
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end

    # * CREATE
    context "POST create" do
      before do
        get new_user_path
        @valid = FactoryBot.attributes_for(:user)
        @invalid = FactoryBot.attributes_for(:invalid_user)
      end

      context "with valid attributes" do
        before do
          post users_path, params: {user: @valid}
          @user = User.find_by(its: @valid[:its])
        end

        scenario "should create a new User" do
          expect(@user).to be_truthy
        end

        scenario "should redirect to index path of User" do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to admin_path
        end
      end

      context "with invalid attributes" do
        before do
          post users_path, params: {user: @invalid}
          @invalid_user = User.find_by(its: @invalid[:its])
        end

        scenario "does not create a new User" do
          expect(@invalid_user).to be_nil
        end

        scenario "should render a new template" do
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

      scenario "should render a show template" do
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      scenario "should render the instance that was passed in the params" do
        # it could be any attribute, not only ITS
        expect(response.body).to include(@user.its.to_s)
      end
    end

    # * INDEX
    context "GET index" do
      before { get admin_path }

      scenario "should render a index template with 200 status code" do
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

      scenario "should destroy the other user" do
        expect(@user).to be_nil
      end

      scenario "should redirect to the login path" do
        expect(response).to redirect_to admin_path
      end
    end
  end

  # * NOT ADMIN
  context "NOT an 'admin', CANNOT access 👉" do
    before do
      @user = FactoryBot.create(:user_other_than_admin, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
      @other_user = FactoryBot.create(:user_other_than_admin, password: @password)
    end

    # * NEW
    context "GET new" do
      before { get new_user_path }

      scenario "should NOT render the 'new' template" do
        expect(response).not_to render_template(:new)
      end

      scenario "should respond with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      scenario "should redirect to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * SHOW page of other users
    context "GET show  of other user" do
      before { get user_path(@other_user) }

      scenario "should NOT render the 'show' template" do
        expect(response).not_to render_template(:show)
      end

      scenario "should respond with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      scenario "should redirect to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * INDEX
    context "GET index" do
      before { get admin_path }

      scenario "should NOT render the 'index' template" do
        expect(response).not_to render_template(:index)
      end

      scenario "should respond with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      scenario "should redirect to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
