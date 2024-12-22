# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User index template" do
  let!(:other_user) { create(:user) }

  before do
    sign_in(user)
    visit users_path
  end

  # * Admin
  describe "visited by admin" do
    let(:user) { create(:admin_user) }

    it { expect(page).to have_title "Users" }

    describe "can see all users details" do
      it "name as a button & role" do
        expect(page).to have_content(other_user.roles_name.first.capitalize)

        expect(page).to have_content(other_user.name)
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

    it_behaves_like "an unauthorized action"
  end
end
