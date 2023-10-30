# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali show template" do
  let(:user) { create(:user) }
  let(:thaali) { create(:taking_thaali_partial_amount_paid) }

  before do
    page.set_rack_session(user_id: user.id)
    visit thaali_path(thaali)
  end

  # * ALL user types
  describe "visited by any user type can view" do
    describe "thaali details" do
      it { expect(page).to have_content(thaali.size.humanize) }
      it { expect(page).to have_content(number_with_delimiter(thaali.total)) }
      it { expect(page).to have_content(number_with_delimiter(thaali.balance)) }
    end

    describe "action buttons" do
      it { expect(page).to have_link("Edit") }
      it { expect(page).to have_button("Delete") }
    end

    describe "transaction details" do
      let(:transaction) { thaali.transactions.first }

      it do
        expect(page).to have_content("Total number of Transactions: #{thaali.transactions.count}")
      end

      it { expect(page).to have_content(transaction.recipe_no.to_s) }
      it { expect(page).to have_content(number_with_delimiter(transaction.amount)) }
      it { expect(page).to have_content(time_ago_in_words(transaction.date)) }
    end
  end
end
