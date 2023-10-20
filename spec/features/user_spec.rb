# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User" do
  # * Admins & Members
  describe "'Admin' & 'Member' visit" do
    let(:user) { create(:user_other_than_viewer) }

    before { page.set_rack_session(user_id: user.id) }

    # * SHOW
    describe "'show' template" do
      before { visit user_path(user) }

      context "with user details" do
        it { within("#show-user") { expect(page).to have_content(user.name) } }

        it { within("#show-user") { expect(page).to have_content(user.its) } }

        it { within("#show-user") { expect(page).to have_content(user.role.humanize) } }
      end

      context "with action buttons" do
        it { expect(page).to have_link("Edit") }
        it { expect(page).to have_button("Delete") }
      end
    end

    # * EDIT / UPDATE
    describe "'edit' template" do
      before { visit edit_user_path(user) }

      describe "update user detials" do
        context "with valid values" do
          let(:new_password) { attributes_for(:user)[:password].to_s }

          it "is successful" do
            fill_in "user_password", with: new_password
            fill_in "user_password_confirmation", with: new_password

            click_button "Update Password"
            expect(page).to have_content("User updated successfully")
          end
        end

        context "with invalid values" do
          before { click_button "Update Password" }

          it "render validation error messages for 'password' field" do
            expect(page).to have_content("Password must be more than 6 characters")
          end
        end
      end
    end

    # * DELETE
    describe "'destroy' action" do
      before do
        visit user_path(user)
        click_button "Delete"
      end

      describe "on deleting user" do
        it "shows confirmation message" do
          within(".modal-body") do
            expect(page).to have_content("Are you sure you want to delete User: #{user.name}? This action cannot be undone.")
          end
        end

        context "with action buttons" do
          it { within(".modal-footer") { expect(page).to have_css(".btn-secondary", text: "Cancel") } }
          it { within(".modal-footer") { expect(page).to have_css(".btn-primary", text: "Yes, delete it!") } }
        end

        describe "delete user" do
          before { click_button "Yes, delete it!" }

          it { expect(page).to have_current_path login_path }
          it { expect(page).to have_content("User deleted successfully") }
        end
      end
    end
  end

  # * Admin
  describe "'Admin' visit" do
    let(:admin) { create(:admin_user) }

    before do
      page.set_rack_session(user_id: admin.id)
      visit root_path
    end

    #  * CREATE
    describe "'new' template to create new user" do
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

    # * INDEX
    describe "'index' template" do
      let!(:other_user) { create(:user) }

      before { visit users_path }

      describe "show all users details" do
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
end
