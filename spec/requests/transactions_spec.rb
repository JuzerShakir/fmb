# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction request - user type 👉" do
  before do
    @password = Faker::Internet.password(min_length: 6, max_length: 72)
  end

  # * Accessible by all
  context "any user can access 👉" do
    before do
      @user = create(:user, password: @password)
      post signup_path, params: {sessions: @user.attributes.merge({password: @password})}
    end

    # * ALL
    context "GET ALL" do
      before do
        get transactions_all_path
      end

      it "renders a 'all' template" do
        expect(response).to render_template(:all)
        expect(response).to have_http_status(:ok)
      end
    end

    # * SHOW
    context "GET show" do
      before do
        @transaction = create(:transaction)
        get transaction_path(@transaction)
      end

      it "renders a show template" do
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only amount
        amount = number_with_delimiter(@transaction.amount)
        expect(response.body).to include(amount)
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

      context "if thaali_takhmeen IS COMPLETED" do
        before do
          @thaali = create(:completed_takhmeens, sabeel_id: @sabeel.id)
          get new_takhmeen_transaction_path(@thaali)
        end

        it "DOES NOT render new tempelate" do
          expect(response).to redirect_to takhmeen_path(@thaali)
        end
      end

      context "if thaali_takhmeen IS NOT COMPLETED" do
        before do
          @thaali = create(:thaali_takhmeen, sabeel_id: @sabeel.id)
          get new_takhmeen_transaction_path(@thaali)
        end

        it "returns a 200 (OK) status code" do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:new)
        end
      end
    end

    # * CREATE
    context "POST create" do
      before do
        @thaali = create(:thaali_takhmeen)
      end

      context "with valid attributes" do
        before do
          @valid_attributes = attributes_for(:transaction)
          post takhmeen_transactions_path(@thaali), params: {transaction: @valid_attributes}
          @transaction = Transaction.find_by(recipe_no: @valid_attributes[:recipe_no])
        end

        it "creates a new Transaction" do
          expect(@transaction).to be_truthy
        end

        it "redirects to created Transaction" do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to @transaction
        end
      end

      context "with invalid attributes" do
        before do
          @invalid_attributes = attributes_for(:transaction, amount: nil)
          post takhmeen_transactions_path(@thaali), params: {transaction: @invalid_attributes}
          @transaction = Transaction.find_by(recipe_no: @invalid_attributes[:recipe_no])
        end

        it "does not create a new Transaction" do
          expect(@transaction).to be_nil
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
        @transaction = create(:transaction)
        get edit_transaction_path(@transaction)
      end

      it "renders render an edit template" do
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute
        expect(response.body).to include(@transaction.recipe_no.to_s)
      end
    end

    # * UPDATE
    context "PATCH update" do
      before do
        @transaction = create(:transaction)
      end

      context "with valid attributes" do
        before do
          @transaction.amount = Random.rand(1..100)
          patch transaction_path(@transaction), params: {transaction: @transaction.attributes}
        end

        it "redirects to updated Transaction page" do
          expect(response).to redirect_to @transaction
        end
      end

      context "with invalid attributes" do
        before do
          @transaction.recipe_no = -123
          patch transaction_path(@transaction), params: {transaction: @transaction.attributes}
        end

        it "renders an edit template" do
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * DESTROY
    context "DELETE destroy" do
      before do
        @thaali = create(:thaali_takhmeen)
        transaction = create(:transaction, thaali_takhmeen_id: @thaali.id)
        delete transaction_path(transaction)
        # find method will raise an error
        @transaction = Transaction.find_by(id: transaction.id)
      end

      it "destroys the Transaction" do
        expect(@transaction).to be_nil
      end

      it "redirects to its parent Thaali Takhmeen page" do
        expect(response).to redirect_to takhmeen_path(@thaali)
      end
    end
  end

  # * NOT Accessible by Viewers
  context "'viewer' CANNOT access 👉" do
    before do
      @viewer = create(:viewer_user, password: @password)
      post signup_path, params: {sessions: @viewer.attributes.merge({password: @password})}
    end

    # * NEW
    context "GET new" do
      before do
        thaali = create(:completed_takhmeens)
        get new_takhmeen_transaction_path(thaali)
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
        transaction = create(:transaction)
        get edit_transaction_path(transaction)
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
        thaali = create(:thaali_takhmeen)
        transaction = create(:transaction, thaali_takhmeen_id: thaali.id)
        delete transaction_path(transaction)
        # find method will raise an error
        @transaction = Transaction.find_by(id: transaction.id)
      end

      it "does not destroy the thaali" do
        expect(@transaction).not_to be_nil
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
