# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ThaaliTakhmeen new template" do
  let(:sabeel) { create(:sabeel) }

  before do
    page.set_rack_session(user_id: user.id)
    visit new_sabeel_takhmeen_path(sabeel)
  end

  # * Admins & Members
  describe "Admin or Member" do
    let(:user) { create(:user_other_than_viewer) }

    context "when sabeel DIDN'T take it in previous year" do
      describe "displays with empty form fields" do
        it { expect(find_field("Number").value).to be_nil }
        it { expect(find_field("Size").value).to eq "" }
        it { expect(find_field("Total").value).to be_nil }
      end
    end

    context "when sabeel did take it in previous year" do
      let(:sabeel) { create(:sabeel_with_previous_takhmeen) }
      let(:thaali) { sabeel.thaali_takhmeens.first }

      describe "displays form fields with previous values" do
        it { expect(find_field("Number").value).to eq thaali.number.to_s }
        it { expect(find_field("Size").value).to eq thaali.size.to_s }
      end
    end

    #  * CREATE
    describe "creating thaali" do
      let(:thaali) { attributes_for(:thaali_takhmeen, sabeel:) }

      before do
        fill_in "thaali_takhmeen_number", with: thaali[:number]
        fill_in "thaali_takhmeen_total", with: thaali[:total]
      end

      context "with valid values" do
        before do
          select thaali[:size].to_s.titleize, from: :thaali_takhmeen_size
          click_button "Create Thaali takhmeen"
        end

        it "redirects to newly created thaali" do
          thaali_takhmeen = ThaaliTakhmeen.last
          expect(page).to have_current_path takhmeen_path(thaali_takhmeen)
        end

        it { expect(page).to have_content("Thaali created successfully") }
      end

      context "with invalid values" do
        before { click_button "Create Thaali takhmeen" }

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
