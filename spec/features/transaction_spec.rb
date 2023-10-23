# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction" do
  before { page.set_rack_session(user_id: user.id) }

  # * ALL user types
  describe "Any logged-in users can visit" do
    let(:user) { create(:user) }

    before { visit root_path }

    # * SHOW
    describe "'show' template" do
      let(:transaction) { create(:transaction) }

      before { visit transaction_path(transaction) }

      context "with action buttons" do
        it { expect(page).to have_link("Edit") }
        it { expect(page).to have_button("Delete") }
      end

      context "with transaction details" do
        it { expect(page).to have_content(transaction.recipe_no) }
        it { expect(page).to have_content(number_with_delimiter(transaction.amount)) }
        it { expect(page).to have_content(transaction.mode.humanize) }
        it { expect(page).to have_content(transaction.date.to_time.strftime("%A, %b %d %Y")) }
      end
    end

    # * INDEX
    describe "'index' template", :js do
      let!(:transactions) { create_list(:transaction, 2) }

      before { visit transactions_all_path }

      describe "show all transaction details" do
        it "recipe_no" do
          transactions.each do |transaction|
            recipe_no = transaction.recipe_no.to_s
            expect(page).to have_content(recipe_no)
          end
        end

        it "amount" do
          transactions.each do |transaction|
            amount = number_with_delimiter(transaction.amount)
            expect(page).to have_content(amount)
          end
        end

        it "date" do
          transactions.each do |transaction|
            date = time_ago_in_words(transaction.date)
            expect(page).to have_content(date)
          end
        end

        it "thaali number" do
          transactions.each do |transaction|
            number = transaction.thaali_takhmeen.number
            expect(page).to have_content(number)
          end
        end
      end

      describe "search" do
        context "with recipe number" do
          let!(:recipes) { transactions.pluck(:recipe_no) }

          before { fill_in "q_recipe_no_cont", with: recipes.first }

          it { within("div#all-transactions") { expect(page).to have_content(recipes.first) } }
          it { within("div#all-transactions") { expect(page).not_to have_content(recipes.last) } }
        end
      end
    end
  end

  # * Admins & Members
  describe "'Admin' & 'Member'" do
    let(:user) { create(:user_other_than_viewer) }

    # * CREATE
    describe "creating it" do
      before do
        thaali = create(:thaali_takhmeen)
        visit new_takhmeen_transaction_path(thaali)

        attributes_for(:transaction).except(:mode, :date).each do |k, v|
          fill_in "transaction_#{k}", with: v
        end
      end

      context "with valid values" do
        let(:new_transaction) { Transaction.last }

        before do
          select Transaction.modes.keys.sample.to_s.titleize, from: :transaction_mode
          click_button "Create Transaction"
        end

        it "redirects to newly created transaction" do
          expect(page).to have_current_path transaction_path(new_transaction)
        end

        it { expect(page).to have_content("Transaction created successfully") }
      end

      context "with invalid values" do
        before { click_button "Create Transaction" }

        it "shows validation error messsage for mode field" do
          expect(page).to have_content(I18n.t("activerecord.errors.models.transaction.attributes.mode.blank"))
        end
      end
    end

    # * EDIT / UPDATE
    describe "editing it" do
      let!(:transaction) { create(:transaction) }
      let(:total) { transaction.thaali_takhmeen.total }

      before { visit edit_transaction_path(transaction) }

      describe "updating it" do
        it "displays correct amount limit (total) as a hint" do
          within(".transaction_amount") do
            expect(page).to have_css("small", text: "Amount shouldn't be greater than: #{total.humanize}")
          end
        end

        context "with valid values" do
          before do
            fill_in "transaction_amount", with: Faker::Number.number(digits: 4)
            click_button "Update Transaction"
          end

          it "redirects to newly updated transaction" do
            expect(page).to have_current_path transaction_path(transaction)
          end

          it { expect(page).to have_content("Transaction updated successfully") }
        end

        context "with invalid values" do
          before do
            incorrect_amount = total + Random.rand(1..100)
            fill_in "transaction_amount", with: incorrect_amount
            click_button "Update Transaction"
          end

          it "shows validation error message for amount field" do
            within(".transaction_amount") do
              expect(page).to have_content("Amount cannot be greater than the balance")
            end
          end
        end
      end
    end

    # * DELETE
    describe "destroying transaction" do
      let(:transaction) { create(:transaction) }

      before do
        visit transaction_path(transaction)
        click_button "Delete"
      end

      it "shows confirmation message" do
        within(".modal-body") do
          expect(page).to have_content("Are you sure you want to delete Transaction reciepe no: #{transaction.recipe_no}? This action cannot be undone.")
        end
      end

      context "with action buttons" do
        it { within(".modal-footer") { expect(page).to have_css(".btn-secondary", text: "Cancel") } }
        it { within(".modal-footer") { expect(page).to have_css(".btn-primary", text: "Yes, delete it!") } }
      end

      describe "destroy" do
        before { click_button "Yes, delete it!" }

        it { expect(page).to have_current_path takhmeen_path(transaction.thaali_takhmeen) }
        it { expect(page).to have_content("Transaction destroyed successfully") }
      end
    end
  end
end
