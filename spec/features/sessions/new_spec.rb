# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions New template" do
  let(:user) { create(:user) }

  context "when user is not logged in" do
    before { visit login_path }

    it "shows footer" do
      expect(page).to have_css("#footer")
    end

    describe "logging in" do
      before { fill_in "sessions_its", with: user.its }

      context "with valid credentials" do
        before do
          fill_in "sessions_password", with: user.password
          click_button "Login"
        end

        it "redirects to root path after login" do
          expect(page).to have_current_path root_path, ignore_query: true
        end

        it "displays welcome message" do
          expect(page).to have_content("Afzalus Salaam")
        end
      end

      context "with invalid credentials" do
        before do
          fill_in "sessions_password", with: ""
          click_button "Login"
        end

        it "displays validation error" do
          expect(page).to have_content("Invalid credentials")
        end
      end
    end
  end

  context "when user is logged in" do
    before do
      page.set_rack_session(user_id: user.id)
      visit login_path
    end

    it "will redirect to root path" do
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end
end