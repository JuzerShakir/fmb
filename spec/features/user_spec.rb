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
            expect(current_path).to eql admin_path
            expect(page).to have_content("User created successfully")
        end

        scenario "should NOT be able to create with invalid values" do
            attributes = FactoryBot.attributes_for(:invalid_user)

            attributes.each do |k, v|
                fill_in "user_#{k}", with: "#{v}"
            end

            click_button "Create User"

            expect(page).to have_content("Please review the problems below:")
            expect(page).to have_content("Password confirmation doesn't match Password")
        end
    end

    # * INDEX
    context "index template" do
        before do
            @users = FactoryBot.create_list(:user, 3)
            visit admin_path
        end

        scenario "should have a heading" do
            expect(page).to have_css('h2', text: "All Users")
        end

        scenario "should show Name & role of all Users" do
            @users.each do |user|
                expect(page).to have_content("#{user.name}")
            end
        end

        scenario "should have a link to 'name' that renders user:show page after clicking it" do
            @users.each do |user|
                expect(page).to have_content("#{user.name}")

                click_on "#{user.name}"
                expect(current_path).to eql user_path(user)
                visit admin_path
            end
        end
    end

    # * SHOW
    context "Show template" do
        before do
            @user = FactoryBot.create(:user)
            visit user_path(@user)
        end

        scenario "should have a heading" do
            expect(page).to have_css('h2', text: "Show User")
        end

        scenario "Showing a User details" do
            attrbs = FactoryBot.attributes_for(:user).except(:password, :password_confirmation)

            attrbs.keys.each do | attrb |
                expect(page).to have_content("#{@user.send(attrb)}")
            end
        end
    end

    # * DELETE
    scenario "Deleting a User" do
        @user = FactoryBot.create(:user)
        visit user_path(@user)

        expect(page).to have_button('Delete User')

        click_on "Delete User"
        click_on "Yes, delete it!"

        expect(current_path).to eql admin_path
        # expect(current_path).to eql login_path
        expect(page).to have_content("User deleted successfully")
    end
end