# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Show template" do
  let(:sabeel) { create(:sabeel_taking_thaali) }
  let(:count) { sabeel.thaalis.count }
  let(:thaali) { sabeel.thaalis.first }

  before do
    page.set_rack_session(user_id: user.id)
    visit sabeel_path(sabeel)
  end

  # * ALL user types
  describe "visited by any user type can view" do
    let(:user) { create(:user) }

    describe "sabeel details" do
      it { expect(page).to have_content(sabeel.its) }
      it { expect(page).to have_content(sabeel.name) }
      it { expect(page).to have_content(sabeel.address) }
      it { expect(page).to have_content(sabeel.mobile) }
      it { expect(page).to have_content(sabeel.email) }
    end

    describe "thaali details" do
      it { expect(page).to have_content("Total number of Thaalis: #{count}") }
      it { expect(page).to have_content(thaali.year) }
      it { expect(page).to have_content(number_with_delimiter(thaali.total)) }
      it { expect(page).to have_content(number_with_delimiter(thaali.balance)) }
    end
  end

  describe "visited by admin or member can view" do
    let(:user) { create(:user_admin_or_member) }

    describe "action buttons" do
      it { expect(page).to have_link("Edit") }
      it { expect(page).to have_button("Delete") }
    end

    describe "thaali details" do
      context "when it's NOT CURRENTLY taking it" do
        let(:sabeel) { create(:sabeel) }

        it { expect(page).to have_button("New Thaali") }
      end

      context "when it's CURRENTLY taking it" do
        it { expect(page).not_to have_button("New Thaali") }
      end
    end
  end

  describe "visited by viewer cannot view" do
    let(:sabeel) { create(:sabeel) }
    let(:user) { create(:viewer_user) }

    describe "action buttons" do
      it { expect(page).not_to have_link("Edit") }
      it { expect(page).not_to have_button("Delete") }
      it { expect(page).not_to have_button("New Thaali") }
    end
  end
end
