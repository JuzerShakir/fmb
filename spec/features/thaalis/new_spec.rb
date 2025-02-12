# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali new template" do
  let(:sabeel) { create(:sabeel) }

  before do
    sign_in(user)
    visit new_sabeel_thaali_path(sabeel)
  end

  # * Admins & Members
  describe "Admin or Member" do
    let(:user) { create(:user_admin_or_member) }

    it { expect(page).to have_title "New Thaali" }

    context "when sabeel DIDN'T take it in previous year" do
      it "displays with empty form fields" do
        expect(find_field("Number").value).to be_nil
        expect(find_field("Small")).not_to be_checked
        expect(find_field("Medium")).not_to be_checked
        expect(find_field("Large")).not_to be_checked
        expect(find_field("Total").value).to be_nil
      end
    end

    context "when sabeel did take it in previous year" do
      let(:sabeel) { create(:sabeel_took_thaali) }
      let(:thaali) { sabeel.thaalis.first }

      it "displays form fields with previous values" do
        expect(find_field("Number").value).to eq thaali.number.to_s
        expect(find_field(thaali.size.capitalize)).to be_checked
      end
    end

    #  * CREATE
    describe "creating thaali" do
      let(:thaali) { attributes_for(:thaali, sabeel:) }

      before do
        fill_in "thaali_number", with: thaali[:number]
        fill_in "thaali_total", with: thaali[:total]
      end

      context "with valid values" do
        before do
          choose thaali[:size].to_s.titleize
          click_on "Create Thaali"
        end

        it "redirects to newly created thaali with success message" do
          thaali = Thaali.last
          expect(page).to (have_current_path thaali_path(thaali)).and have_content("Thaali created")
        end
      end

      context "with invalid values" do
        before { click_on "Create Thaali" }

        it { expect(page).to have_content("selection is required") }
      end
    end
  end
end
