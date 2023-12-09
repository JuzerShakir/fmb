# frozen_string_literal: true

require "rails_helper"

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
      it { expect(page).to have_content(number_with_delimiter(thaali.total)) }
      it { expect(page).to have_content(number_with_delimiter(thaali.balance)) }
      it { expect(page).to have_content(number_with_delimiter(thaali.paid)) }

      describe "if its dues are cleared" do
        let(:thaali) { create(:taking_thaali_dues_cleared) }

        it "balance amount is not shown" do
          within("#payment-summary") do
            expect(page).not_to have_content(number_with_delimiter(thaali.balance))
          end
        end

        it "paid amount is not shown" do
          within("#payment-summary") do
            expect(page).not_to have_content(number_with_delimiter(thaali.paid))
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
      let(:transaction) { thaali.transactions.first }

      it do
        expect(page).to have_content("Total number of Transactions: #{thaali.transactions.count}")
      end

      it { expect(page).to have_content(transaction.recipe_no.to_s) }
      it { expect(page).to have_content(number_with_delimiter(transaction.amount)) }
      it { expect(page).to have_content(time_ago_in_words(transaction.date)) }
    end
  end

  describe "visited by admin or member can view" do
    let(:user) { create(:user_admin_or_member) }

    describe "action buttons" do
      it { expect(page).to have_link("Edit") }
      it { expect(page).to have_button("Delete") }

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
      it { expect(page).not_to have_link("Edit") }
      it { expect(page).not_to have_button("Delete") }
      it { expect(page).not_to have_link("New Transaction") }
    end
  end
end
