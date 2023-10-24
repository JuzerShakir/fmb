# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User index template" do
  let(:admin) { create(:admin_user) }
  let!(:other_user) { create(:user) }

  before do
    page.set_rack_session(user_id: admin.id)
    visit users_path
  end

  # * Admin
  describe "visited by admin" do
    describe "can see all users details" do
      it "name" do
        expect(page).to have_content(other_user.name)
      end

      it "role" do
        expect(page).to have_content(other_user.role.capitalize)
      end

      it "button" do
        click_button other_user.name.to_s
        expect(page).to have_current_path user_path(other_user)
      end
    end

    it "will not show current admin details" do
      expect(page).not_to have_content(admin.name)
    end
  end
end
