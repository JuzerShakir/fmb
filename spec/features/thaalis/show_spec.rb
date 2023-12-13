# frozen_string_literal: true

require "rails_helper"
require_relative "../transactions/transaction_helpers"
require_relative "../shared_helpers"

RSpec.describe "Thaali show template" do
  let(:thaali) { create(:taking_thaali_partial_amount_paid) }

  before do
    page.set_rack_session(user_id: user.id)
    visit thaali_path(thaali)
  end

  # * ALL user types
  describe "visited by any user type can view" do
    let(:user) { create(:user) }

    describe "thaali details" do
      it { expect(page).to have_content(thaali.size.humanize) }

      it_behaves_like "abbreviated numbers" do
        let(:number) { thaali.total }
      end

      it_behaves_like "abbreviated numbers" do
        let(:number) { thaali.paid }
      end

      it_behaves_like "abbreviated numbers" do
        let(:number) { thaali.balance }
      end

      describe "if its dues are cleared" do
        let(:thaali) { create(:taking_thaali_dues_cleared) }

        it "balance amount is not shown" do
          within("#payment-summary") do
            expect(page).not_to have_content(number_to_human(thaali.balance, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"}))
          end
        end

        it "paid amount is not shown" do
          within("#payment-summary") do
            expect(page).not_to have_content(number_to_human(thaali.paid, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"}))
          end
        end

        it "a prompt is shown" do
          within("#payment-summary") do
            expect(page).to have_content("Takhmeen Complete")
          end
        end
      end
    end

    describe "transaction details" do
      let(:transactions) { thaali.transactions }

      it do
        expect(page).to have_content("Total number of Transactions: #{thaali.transactions.count}")
      end

      it_behaves_like "view transaction records"
    end
  end

  describe "visited by admin or member can view" do
    let(:user) { create(:user_admin_or_member) }

    describe "action buttons" do
      it_behaves_like "show_edit_delete"

      describe "New Transaction button" do
        context "when amount is partially paid" do
          it { expect(page).to have_link("New Transaction") }
        end

        context "when amount is fully paid" do
          let(:thaali) { create(:taking_thaali_dues_cleared) }

          it { expect(page).not_to have_link("New Transaction") }
        end
      end
    end
  end

  describe "visited by viewer cannot view" do
    let(:user) { create(:viewer_user) }

    describe "action buttons" do
      it_behaves_like "hide_edit_delete"

      it { expect(page).not_to have_link("New Transaction") }
    end
  end
end
