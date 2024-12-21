# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User new template" do
  let(:user) { create(:admin_user) }

  before do
    # rubocop:disable Rails/SkipsModelValidations
    Role.insert_all([{name: "member"}, {name: "viewer"}])
    # rubocop:enable Rails/SkipsModelValidations
    sign_in(user)
    visit thaalis_all_path(CURR_YR)
  end

  # * Admin
  describe "admin creating it" do
    before do
      find_by_id("new_user").click

      attributes_for(:user).each do |k, v|
        case k
        when :roles then choose Role::NAMES.sample.titleize
        else fill_in "user_#{k}", with: v
        end
      end
    end

    it { expect(page).to have_title "New User" }

    context "with valid values" do
      before { click_on "Create User" }

      it "is successfully created" do
        expect(page).to have_content("User created")
      end
    end

    context "with invalid values" do
      before do
        fill_in "user_password", with: ""
        click_on "Create User"
      end

      it "returns a validation error message for password field" do
        expect(page).to have_content("Password can't be blank")
      end
    end
  end

  # * Viewer or Member
  describe "visited by 'Viewer' or 'Member'" do
    let(:user) { create(:user_member_or_viewer) }

    before { visit new_user_path }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path thaalis_all_path(CURR_YR) }
  end
end
