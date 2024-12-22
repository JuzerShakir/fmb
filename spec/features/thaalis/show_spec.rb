# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali show template" do
  let(:thaali) { create(:taking_thaali_partial_amount_paid) }

  before do
    sign_in(user)
    visit thaali_path(thaali)
  end

  # * ALL user types
  describe "visited by any user type can view" do
    let(:user) { create(:user) }

    describe "thaali details" do
      it do
        expect(page).to have_title "Thaali no. #{thaali.number}"
        expect(page).to have_content(thaali.size.humanize)
        expect(page).to have_humanized_number(thaali.total)
      end

      context "when dues are not cleared" do
        it "shows paid & balance amounts" do
          expect(page).to have_humanized_number(thaali.paid)
          expect(page).to have_humanized_number(thaali.balance)
        end
      end

      context "when dues are cleared" do
        let!(:thaali) { create(:taking_thaali_dues_cleared) }

        before { visit thaali_path(thaali) }

        it "balance & paid amount is not shown but a prompt is shown" do
          within("#payment-summary") do
            scope_to_text = page.text

            expect(scope_to_text).not_to have_humanized_number(thaali.balance)
            expect(scope_to_text).not_to have_humanized_number(thaali.paid)
            expect(scope_to_text).to have_content("Takhmeen Complete")
          end
        end
      end
    end

    describe "transaction details" do
      let(:transactions) { thaali.transactions }

      it { expect(page).to have_content("Total number of Transactions: #{transactions.count}") }

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

          it { expect(page).to have_no_link("New Transaction") }
        end
      end
    end
  end

  describe "visited by viewer cannot view" do
    let(:user) { create(:viewer_user) }

    describe "action buttons" do
      it_behaves_like "hide_edit_delete"

      it { expect(page).to have_no_link("New Transaction") }
    end
  end
end
