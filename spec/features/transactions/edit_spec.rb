# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction edit template" do
  let!(:transaction) { create(:transaction) }
  let(:total) { transaction.thaali.total }

  before do
    page.set_rack_session(user_id: user.id)
    visit edit_transaction_path(transaction)
  end

  # * Admins & Members
  describe "visited by Admin or Member" do
    let(:user) { create(:user_other_than_viewer) }

    it "displays correct amount limit (total) as a hint" do
      within(".transaction_amount") do
        expect(page).to have_css("small", text: "Amount shouldn't be greater than: #{total.humanize}")
      end
    end

    describe "updating" do
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

  # * Viewer
  describe "visited by 'Viewer'" do
    let(:user) { create(:viewer_user) }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path root_path }
  end
end
