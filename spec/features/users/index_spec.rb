# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User index template" do
  let!(:other_user) { create(:user) }

  before do
    page.set_rack_session(user_id: user.id)
    visit users_path
  end

  # * Admin
  describe "visited by admin" do
    let(:user) { create(:admin_user) }

    it { expect(page).to have_title "Users" }

    describe "can see all users details" do
      it "name" do
        expect(page).to have_content(other_user.name)
      end

      it "role" do
        expect(page).to have_content(other_user.roles_name.first.capitalize)
      end

      it "button" do
        click_on other_user.name
        expect(page).to have_current_path user_path(other_user)
      end
    end

    it "does not show current admin details" do
      expect(page).to have_no_content(user.name)
    end
  end

  # * Member or Viewer
  describe "visited by Member or Viewer" do
    let(:user) { create(:user_member_or_viewer) }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path thaalis_all_path(CURR_YR) }
  end
end
