# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali new template" do
  let(:sabeel) { create(:sabeel) }

  before do
    page.set_rack_session(user_id: user.id)
    visit new_sabeel_thaali_path(sabeel)
  end

  # * Admins & Members
  describe "Admin or Member" do
    let(:user) { create(:user_admin_or_member) }

    context "when sabeel DIDN'T take it in previous year" do
      describe "displays with empty form fields" do
        it { expect(find_field("Number").value).to be_nil }
        it { expect(find_field("Size").value).to eq "" }
        it { expect(find_field("Total").value).to be_nil }
      end
    end

    context "when sabeel did take it in previous year" do
      let(:sabeel) { create(:sabeel_took_thaali) }
      let(:thaali) { sabeel.thaalis.first }

      describe "displays form fields with previous values" do
        it { expect(find_field("Number").value).to eq thaali.number.to_s }
        it { expect(find_field("Size").value).to eq thaali.size.to_s }
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
          select thaali[:size].capitalize, from: :thaali_size
          click_button "Create Thaali"
        end

        it "redirects to newly created thaali" do
          thaali = Thaali.last
          expect(page).to have_current_path thaali_path(thaali)
        end

        it { expect(page).to have_content("Thaali created successfully") }
      end

      context "with invalid values" do
        before { click_button "Create Thaali" }

        it { expect(page).to have_content("selection is required") }
      end
    end
  end

  # * Viewer
  describe "visited by Viewer" do
    let(:user) { create(:viewer_user) }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path root_path }
  end
end
