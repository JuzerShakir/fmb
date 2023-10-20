# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions" do
  let(:user) { create(:user) }

  context "when user is not logged in" do
    before { visit login_path }

    it "shows footer" do
      expect(page).to have_css("#footer")
    end

    # * CREATE
    describe "can login with valid credentials" do
      before do
        fill_in "sessions_its", with: user.its
        fill_in "sessions_password", with: user.password
        click_button "Login"
      end

      it "redirects to root path after login" do
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it "displays welcome message" do
        flash_msg = user.viewer? ? "Afzalus Salam" : "Afzalus Salam, #{user.name.split.first} bhai!"
        expect(page).to have_content(flash_msg)
      end
    end

    describe "cannot login with invalid credentials" do
      before do
        fill_in "sessions_its", with: user.its
        fill_in "sessions_password", with: ""
        click_button "Login"
      end

      it "displays validation error" do
        expect(page).to have_content("Invalid credentials!")
      end
    end
  end

  context "when user is logged in, and you visit" do
    before do
      page.set_rack_session(user_id: user.id)
      visit login_path
    end

    # * New
    describe "'new' action" do
      it "will redirect to root path" do
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end

    # * DESTROY
    describe "'destroy' action" do
      before { click_link "Log out" }

      it do
        expect(page).to have_current_path login_path
      end

      it do
        expect(page).to have_content("Logged Out!")
      end

      it "does not show the navbar" do
        expect(page).not_to have_css(".navbar")
      end
    end
  end
end
