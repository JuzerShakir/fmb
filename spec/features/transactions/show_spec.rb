# frozen_string_literal: true

require "rails_helper"
require_relative "../shared_helpers"

RSpec.describe "Transaction show template" do
  let(:transaction) { create(:transaction) }

  before do
    page.set_rack_session(user_id: user.id)
    visit transaction_path(transaction)
  end

  # * ALL user types
  describe "visited by any user type can view" do
    let(:user) { create(:user) }

    it { expect(page).to have_title "Recipe: #{transaction.recipe_no}" }

    describe "transaction details" do
      it { expect(page).to have_content(transaction.recipe_no) }
      it { expect(page).to have_content(number_with_delimiter(transaction.amount)) }
      it { expect(page).to have_content(transaction.mode.capitalize) }
      it { expect(page).to have_content(transaction.date.to_fs(:long)) }
    end
  end

  describe "visited by admin or member can view" do
    let(:user) { create(:user_admin_or_member) }

    describe "action buttons" do
      it_behaves_like "show_edit_delete"
    end
  end

  describe "visited by viewer cannot view" do
    let(:user) { create(:viewer_user) }

    it_behaves_like "hide_edit_delete"
  end
end
