# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User new template" do
  let(:user) { create(:admin_user) }

  before do
    page.set_rack_session(user_id: user.id)
    visit root_path
  end

  # * Admin
  describe "admin creating it" do
    before do
      find_by_id("new_user").click

      attributes_for(:user).each do |k, v|
        case k
        when :role then select User.roles.keys.sample.to_s.titleize, from: :user_role
        else fill_in "user_#{k}", with: v
        end
      end
    end

    context "with valid values" do
      before { click_button "Create User" }

      it "is successfully created" do
        expect(page).to have_content("User created successfully")
      end
    end

    context "with invalid values" do
      before do
        fill_in "user_password", with: ""
        click_button "Create User"
      end

      it "returns a validation error message for password field" do
        expect(page).to have_content("Password can't be blank")
      end
    end
  end

  # * Viewer or Member
  describe "visited by 'Viewer' or 'Member'" do
    let(:user) { create(:user_other_than_admin) }

    before { visit new_user_path }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path root_path }
  end
end