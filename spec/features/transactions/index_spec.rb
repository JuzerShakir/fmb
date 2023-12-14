# frozen_string_literal: true

require "rails_helper"
require_relative "transaction_helpers"

RSpec.describe "Transaction index template" do
  let(:user) { create(:user) }
  let!(:transactions) { create_list(:transaction, 2) }

  before do
    page.set_rack_session(user_id: user.id)
    visit transactions_all_path
  end

  # * ALL user types
  describe "visited by any user type can", :js do
    it_behaves_like "view transaction records"

    describe "search" do
      context "with recipe number" do
        let!(:recipe) { transactions.first.recipe_no }

        before { fill_in "q_slug_start", with: recipe }

        it { within("div#transactions") { expect(page).to have_content(recipe) } }
        it { within("div#transactions") { expect(page).not_to have_content(transactions.last.recipe_no) } }
      end
    end
  end
end
