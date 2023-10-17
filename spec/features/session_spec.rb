# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions accessed by user who are 👉" do
  before do
    @password = Faker::Internet.password(min_length: 6, max_length: 72)
    @user = FactoryBot.create(:user, password: @password)
  end

  context "NOT-logged-in will render template" do
    before do
      visit login_path
    end

    # * NEW
    context "'new'" do
      scenario "should have a correct url and a heading" do
        expect(current_path).to eql login_path
        expect(page).to have_css("h2", text: "Faizul Mawaid il Burhaniyah")
      end
    end

    # * CREATE
    context "creating session" do
      scenario "should be able to login with valid credentials" do
        fill_in "sessions_its", with: @user[:its]
        fill_in "sessions_password", with: @password

        click_button "Login"

        expect(current_path).to eql root_path("format=html")

        if @user.viewer?
          flash_msg = "Afzalus Salam"
        else
          first_name = @user.name.split.first
          flash_msg = "Afzalus Salam, #{first_name} bhai!"
        end

        expect(page).to have_content(flash_msg)
      end

      scenario "should NOT be able to login with invalid credentials" do
        fill_in "sessions_its", with: @user[:its]
        fill_in "sessions_password", with: ""

        click_button "Login"
        expect(page).to have_content("Invalid credentials!")
      end

      scenario "should show footer" do
        expect(page).to have_css("#footer")
      end
    end
  end

  context "logged-in will NOT render template" do
    before do
      page.set_rack_session(user_id: @user.id)
      visit login_path
    end

    context "'new'" do
      scenario "should redirect to the root path" do
        expect(current_path).to eq root_path
      end
    end
  end

  context "logged-in will be able to" do
    before do
      page.set_rack_session(user_id: @user.id)
      visit root_path
    end

    # * DESTROY
    context "'destroy'" do
      before do
        click_on "Log out"
      end

      scenario "should redirect to login_path with flash message" do
        expect(current_path).to eql login_path
        expect(page).to have_content("Logged Out!")
      end

      scenario "should NOT show the navbar" do
        expect(page).not_to have_css(".navbar")
      end
    end
  end
end
