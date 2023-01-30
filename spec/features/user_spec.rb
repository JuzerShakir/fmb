require 'rails_helper'

RSpec.describe "User template 👉" do
    # * NEW / CREATE
    context "'new'" do
        before do
            @user = FactoryBot.create(:user)
            page.set_rack_session(user_id: @user.id)
            visit root_path
            click_on "Admin"
            click_on "New User"
        end

        scenario "should have a correct url and a heading" do
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
    # ! Only admin can access index
    # context "'index'" do
    #     before do
            # @user = FactoryBot.create(:user)
            # page.set_rack_session(user_id: @user.id)
    #         @users = FactoryBot.create_list(:user, 3)
    #         visit admin_path
    #     end

    #     scenario "should have a heading" do
    #         expect(page).to have_css('h2', text: "All Users")
    #     end

    #     scenario "should show Name & role of all Users" do
    #         @users.each do |user|
    #             expect(page).to have_content("#{user.name}")
    #         end
    #     end

    #     scenario "should NOT show current admin details" do
    #          expect(page).to have_no_content("#{user.name}")
    #     end

    #     scenario "should have a link to 'name' that renders user:show page after clicking it" do
    #         @users.each do |user|
    #             expect(page).to have_content("#{user.name}")

    #             click_on "#{user.name}"
    #             expect(current_path).to eql user_path(user)
    #             visit admin_path
    #         end
    #     end
    # end

    # * SHOW
    context "'show'" do
        before do
            @user = FactoryBot.create(:user)
            page.set_rack_session(user_id: @user.id)
            visit user_path(@user)
        end

        scenario "should have a heading" do
            expect(page).to have_css('h2', text: "Show User")
        end

        scenario "shows User details" do
            attrbs = FactoryBot.attributes_for(:user).except(:password, :password_confirmation)

            attrbs.keys.each do | attrb |
                expect(page).to have_content("#{@user.send(attrb)}")
            end
        end

        scenario "should have an edit link" do
            expect(page).to have_link("Edit")
        end

        scenario "should have a 'delete' button" do
            expect(page).to have_button('Delete')
        end

    end

    # * EDIT
    context "'edit'", js: true do
        before do
            @user = FactoryBot.create(:user)
            page.set_rack_session(user_id: @user.id)
            visit edit_user_path(@user)
        end

        scenario "should BE able to update with valid values" do
            new_password = Faker::Internet.password(min_length: 6, max_length: 72)
            fill_in "user_password", with: new_password
            fill_in "user_password_confirmation", with: new_password

            click_on "Update Password"
            expect(current_path).to eql user_path(@user)
            expect(page).to have_content("User updated successfully")
        end

        scenario "should NOT BE able to update with invalid values" do
            fill_in "user_password", with: ""
            fill_in "user_password_confirmation", with: ""

            click_on "Update Password"
            expect(current_path).to eql edit_user_path(@user)
            expect(page).to have_content("Password must be more than 6 characters")
            expect(page).to have_content("Password confirmation cannot be blank")
        end
    end

    # * DELETE
    scenario "'destroy'" do
        @user = FactoryBot.create(:user)
        page.set_rack_session(user_id: @user.id)

        visit user_path(@user)

        click_on "Delete"
        click_on "Yes, delete it!"

        expect(current_path).to eql login_path
        expect(page).to have_content("User deleted successfully")
    end
end