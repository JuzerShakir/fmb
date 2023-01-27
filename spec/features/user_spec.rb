require 'rails_helper'

RSpec.describe "Users features" do
    # * CREATE
    context "creating user" do
        before do
            visit root_path
            click_on "New User"
            expect(current_path).to eql new_user_path

            expect(page).to have_css('h2', text: "New User")
        end

        scenario "should be able to create with valid values" do
            attributes = FactoryBot.attributes_for(:user)

            attributes.each do |k, v|
                fill_in "user_#{k}", with: "#{v}"
            end

            click_button "Create User"

            user = User.last
            expect(current_path).to eql root_path
            expect(page).to have_content("User created successfully")
        end

        # scenario "should NOT be able to create with invalid values" do
        #     attributes = FactoryBot.attributes_for(:invalid_user)

        #     attributes.each do |k, v|
        #         fill_in "user_#{k}", with: "#{v}"
        #     end

        #     click_button "Create user"

        #     expect(page).to have_content("Please review the problems below:")
        #     expect(page).to have_content("Apartment cannot be blank")
        # end
    end
end