# frozen_string_literal: true

require "rails_helper"
require_relative "transaction_helpers"

RSpec.describe "Transaction all template" do
  let(:user) { create(:user) }
  let!(:transactions) { create_list(:transaction, 2) }

  before do
    page.set_rack_session(user_id: user.id)
    visit transactions_all_path
  end

  # * ALL user types
  describe "visited by any user type can", :js do
    it { expect(page).to have_title "Transactions" }

    it_behaves_like "view transaction records"

    describe "search" do
      context "with receipt number" do
        let!(:receipt) { transactions.first.receipt_number }

        before { fill_in "q_slug_start", with: receipt }

        it { within("section#transactions") { expect(page).to have_content(receipt) } }
        it { within("section#transactions") { expect(page).to have_no_content(transactions.last.receipt_number) } }
      end
    end
  end
end
