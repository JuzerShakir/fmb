# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Show template" do
  let(:sabeel) { create(:sabeel_taking_thaali) }
  let(:count) { sabeel.thaalis.count }
  let(:thaali) { sabeel.thaalis.first }

  before do
    sign_in(user)
    visit sabeel_path(sabeel)
  end

  # * ALL user types
  describe "visited by any user type can view" do
    let(:user) { create(:user) }

    it "sabeel details" do
      expect(page).to have_title sabeel.name

      expect(page).to have_content(sabeel.its)
      expect(page).to have_content(sabeel.name)
      expect(page).to have_content(sabeel.address)
      expect(page).to have_content(sabeel.mobile)
      expect(page).to have_content(sabeel.email)
    end

    describe "thaali details" do
      it do
        expect(page).to have_content("Total number of Thaalis: #{count}")
        expect(page).to have_content(thaali.year)
        expect(page).to have_humanized_number(thaali.total)
        expect(page).to have_humanized_number(thaali.balance)
      end
    end
  end

  describe "visited by admin or member can view" do
    let(:user) { create(:user_admin_or_member) }

    describe "action buttons" do
      it_behaves_like "show_edit_delete"
    end

    describe "thaali details" do
      context "when it's NOT CURRENTLY taking it" do
        let(:sabeel) { create(:sabeel) }

        it { expect(page).to have_link("New Thaali") }
      end

      context "when it's CURRENTLY taking it" do
        it { expect(page).to have_no_link("New Thaali") }
      end
    end
  end

  describe "visited by viewer cannot view" do
    let(:sabeel) { create(:sabeel) }
    let(:user) { create(:viewer_user) }

    describe "action buttons" do
      it_behaves_like "hide_edit_delete"

      it { expect(page).to have_no_link("New Thaali") }
    end
  end
end
