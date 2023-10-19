# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction request" do
  # * Accessible by all
  describe "'Anyone' who have logged in can access 👉" do
    # rubocop:disable RSpec/BeforeAfterAll
    before(:all) do
      user = create(:user)
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end
    # rubocop:enable RSpec/BeforeAfterAll

    # * ALL
    describe "GET /all" do
      before { get transactions_all_path }

      it "renders all template" do
        expect(response).to render_template(:all)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    # * SHOW
    describe "GET /show" do
      let(:transaction) { create(:transaction) }

      before { get transaction_path(transaction) }

      it "renders a show template" do
        expect(response).to render_template(:show)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute, not only amount
        amount = number_with_delimiter(transaction.amount)
        expect(response.body).to include(amount)
      end
    end
  end

  # * Accessible by Admins & Members
  describe "'Admin' & 'Member' can access 👉" do
    # rubocop:disable RSpec/BeforeAfterAll
    before(:all) do
      user = create(:user_other_than_viewer)
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end
    # rubocop:enable RSpec/BeforeAfterAll

    # * NEW
    describe "GET /new" do
      context "when thaali_takhmeen IS COMPLETED" do
        let(:thaali) { create(:completed_takhmeens) }

        before { get new_takhmeen_transaction_path(thaali) }

        it "redirects to thaali show page" do
          expect(response).to redirect_to takhmeen_path(thaali)
        end
      end

      context "when thaali_takhmeen IS NOT COMPLETED" do
        let(:thaali) { create(:thaali_takhmeen) }

        before { get new_takhmeen_transaction_path(thaali) }

        it "returns new template" do
          expect(response).to render_template(:new)
        end

        it "returns with 200 status code" do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    # * CREATE
    describe "POST /create" do
      let(:thaali) { create(:thaali_takhmeen) }

      context "with valid values" do
        before do
          valid_attributes = attributes_for(:transaction)
          post takhmeen_transactions_path(thaali), params: {transaction: valid_attributes}
        end

        it "returns with 302 redirect status code" do
          expect(response).to have_http_status(:found)
        end

        it "redirects to created Transaction" do
          expect(response).to redirect_to transaction_path(thaali.transactions.first)
        end
      end

      context "with invalid values" do
        before do
          invalid_attributes = attributes_for(:transaction, amount: nil)
          post takhmeen_transactions_path(thaali), params: {transaction: invalid_attributes}
        end

        it "renders a new template" do
          expect(response).to render_template(:new)
        end

        it "returns with 422 status code" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * EDIT
    describe "GET /edit" do
      let(:transaction) { create(:transaction) }

      before { get edit_transaction_path(transaction) }

      it "renders an edit template" do
        expect(response).to render_template(:edit)
      end

      it "returns with 200 status code" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the instance that was passed in the params" do
        # it could be any attribute
        expect(response.body).to include(transaction.recipe_no.to_s)
      end
    end

    # * UPDATE
    describe "PATCH /update" do
      let(:transaction) { create(:transaction) }

      context "with valid attributes" do
        before do
          transaction.amount = Random.rand(1..100)
          patch transaction_path(transaction), params: {transaction: transaction.attributes}
        end

        it "redirects to updated Transaction page" do
          expect(response).to redirect_to transaction
        end
      end

      context "with invalid attributes" do
        before do
          transaction.recipe_no = -123
          patch transaction_path(transaction), params: {transaction: transaction.attributes}
        end

        it "renders edit template" do
          expect(response).to render_template(:edit)
        end

        it "returns with 422 status code" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # * DESTROY
    describe "DELETE /destroy" do
      let(:transaction) { create(:transaction) }

      before { delete transaction_path(transaction) }

      it "destroys the Transaction" do
        expect(Transaction.find_by(id: transaction.id)).to be_nil
      end

      it "redirects to its parent Thaali Takhmeen page" do
        expect(response).to redirect_to takhmeen_path(transaction.thaali_takhmeen)
      end
    end
  end

  # * NOT Accessible by Viewers
  describe "'Viewer' CANNOT access 👉" do
    # rubocop:disable RSpec/BeforeAfterAll
    before(:all) do
      viewer = create(:viewer_user)
      post signup_path, params: {sessions: viewer.attributes.merge({password: viewer.password})}
    end
    # rubocop:enable RSpec/BeforeAfterAll

    # * NEW
    describe "GET /new" do
      let(:thaali) { create(:completed_takhmeens) }

      before { get new_takhmeen_transaction_path(thaali) }

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * EDIT
    describe "GET /edit" do
      let(:transaction) { create(:transaction) }

      before { get edit_transaction_path(transaction) }

      it "responds with status code '302' (found)" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    # * DETROY
    describe "DELETE /destroy" do
      let(:transaction) { create(:transaction) }

      before { delete transaction_path(transaction) }

      it "does not destroy the thaali" do
        expect(Transaction.find_by(id: transaction.id)).to be_persisted
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
