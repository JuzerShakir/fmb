require 'rails_helper'

RSpec.describe "Transactions", type: :request do
    # * ALL
    context "GET all" do
        before do
            @transactions = FactoryBot.create_list(:transaction, 5)
            get all_transactions_path
        end

        it "should render a 'index' template" do
            expect(response).to render_template(:index)
            expect(response).to have_http_status(:ok)
        end

        it "should show all transactions of all thaalis" do
            @transactions.each do |transaction|
                expect(response.body).to  include("#{transaction.recipe_no}")
            end
        end
    end

    # * NEW
    context "GET new" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen)
            get new_takhmeen_transaction_path(id: @thaali.id)
        end

        it "should return a 200 (OK) status code" do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template(:new)
        end
    end

    # * CREATE
    context "POST create" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen)
        end

        context "with valid attributes" do
            before do
                @valid_attributes = FactoryBot.attributes_for(:transaction, thaali_takhmeen_id: @thaali.id)
                post sabeel_takhmeen_transactions_path, params: { transaction: @valid_attributes }
                @transaction = Transaction.find_by(recipe_no: @valid_attributes[:recipe_no])
            end

            it "should create a new Transaction" do
                expect(@transaction).to be_truthy
            end

            it "should redirect to created Transaction" do
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to @transaction
            end
        end

        context "with invalid attributes" do
            before do
                @invalid_attributes = FactoryBot.attributes_for(:transaction, amount: nil)
                post sabeel_takhmeen_transactions_path, params: { transaction: @invalid_attributes }
                @transaction = Transaction.find_by(recipe_no: @invalid_attributes[:recipe_no])
            end

            it "does not create a new Transaction" do
                expect(@transaction).to be_nil
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
            @transaction = FactoryBot.create(:transaction)
            get transaction_path(@transaction)
        end

        it "should render a show template" do
            expect(response).to render_template(:show)
            expect(response).to have_http_status(:ok)
        end

        it "should render the instance that was passed in the params" do
            # it could be any attribute, not only amount
            expect(response.body).to include("#{@transaction.amount}")
        end
    end

    # * EDIT
    context "GET edit" do
      before do
          @transaction = FactoryBot.create(:transaction)
          get edit_transaction_path(@transaction)
      end

      it "should render render an edit template" do
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:ok)
      end

      it "should render the instance that was passed in the params" do
          # it could be any attribute, not only on_date
          expect(response.body).to include("#{@transaction.on_date}")
      end
  end

  # * UPDATE
  context "PATCH update" do
        before do
            @transaction = FactoryBot.create(:transaction)
        end

        context "with valid attributes" do
            before do
                @transaction.amount = Random.rand(1..100)
                patch transaction_path(@transaction), params: { transaction: @transaction.attributes }
            end


            it "should redirect to updated Transaction page" do
                expect(response).to redirect_to @transaction
            end
        end

        context "with invalid attributes" do
            before do
                @transaction.recipe_no = -123
                patch transaction_path(@transaction), params: { transaction: @transaction.attributes }
            end

          it "should render an edit template" do
                expect(response).to render_template(:edit)
                expect(response).to have_http_status(:ok)
          end
        end
    end

    # * DESTROY
    context "DELETE destroy" do
        before do
            transaction = FactoryBot.create(:transaction)
            delete transaction_path(transaction)
            # find method will raise an error
            @transaction = Transaction.find_by(id: transaction.id)
        end

        it "should destroy the Transaction" do
            expect(@transaction).to be_nil
        end

        it "should redirect to its parent Thaali Takhmeen page" do
            expect(response).to redirect_to sabeel_takhmeen_path
        end
    end
end


