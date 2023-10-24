# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction show template" do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction) }

  before do
    page.set_rack_session(user_id: user.id)
    visit transaction_path(transaction)
  end

  # * ALL user types
  describe "visited by any user type can view" do
    describe "action buttons" do
      it { expect(page).to have_link("Edit") }
      it { expect(page).to have_button("Delete") }
    end

    describe "transaction details" do
      it { expect(page).to have_content(transaction.recipe_no) }
      it { expect(page).to have_content(number_with_delimiter(transaction.amount)) }
      it { expect(page).to have_content(transaction.mode.humanize) }
      it { expect(page).to have_content(transaction.date.to_time.strftime("%A, %b %d %Y")) }
    end
  end
end
