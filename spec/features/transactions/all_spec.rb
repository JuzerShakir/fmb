# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction all template" do
  let(:user) { create(:user) }
  let!(:transactions) { create_list(:transaction, 2) }

  before do
    sign_in(user)
    visit transactions_all_path
  end

  # * ALL user types
  it { expect(page).to have_title "Transactions" }

  describe "visited by any user type can", :js do
    it_behaves_like "view transaction records"

    describe "search" do
      context "with receipt number" do
        let!(:receipt) { transactions.first.receipt_number }

        before { fill_in "q_slug_start", with: receipt }

        it "returns correct transaction" do
          within("section#transactions") do
            expect(page).to have_content(receipt)
            expect(page).to have_no_content(transactions.last.receipt_number)
          end
        end
      end
    end
  end
end
