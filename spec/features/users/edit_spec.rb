# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User edit template" do
  let(:user) { create(:user_admin_or_member) }

  before do
    page.set_rack_session(user_id: user.id)
    visit edit_user_path(user)
  end

  # * Admins & Members
  describe "visited by 'Admin' & 'Member'" do
    describe "editing user details" do
      context "with valid values" do
        let(:new_password) { attributes_for(:user)[:password].to_s }

        it "is successful" do
          fill_in "user_password", with: new_password
          fill_in "user_password_confirmation", with: new_password

          click_on "Update Password"
          expect(page).to have_content("User updated")
        end
      end

      context "with invalid values" do
        before { click_on "Update Password" }

        it "render validation error messages for 'password' field" do
          expect(page).to have_content("Password must be more than 6 characters")
        end
      end
    end
  end
end
