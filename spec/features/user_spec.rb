require "rails_helper"

RSpec.describe "User accessed by users who are 👉" do
  # * NON-LOGGED-IN users
  context "not-logged-in will NOT render template" do
    before do
      @user = FactoryBot.create(:user)
    end

    scenario "'new'" do
      visit new_user_path
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'show'" do
      visit user_path(@user)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'edit'" do
      visit edit_user_path(@user)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'index'" do
      visit users_path
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end
  end

  # * ONLY Admins & Members
  context "'Admin' & 'Member' WILL render template" do
    before do
      @user = FactoryBot.create(:user_other_than_viewer)
      page.set_rack_session(user_id: @user.id)
      visit root_path
    end

    # * SHOW
    context "'show' should have" do
      before do
        visit user_path(@user)
      end

      scenario "a heading" do
        expect(page).to have_css("h2", text: "Show User")
      end

      scenario "User details" do
        within("#show-user") do
          expect(page).to have_content(@user.name)
          expect(page).to have_content(@user.its)
          expect(page).to have_content(@user.role.humanize)
        end
      end

      scenario "an edit link" do
        expect(page).to have_link("Edit")
      end

      scenario "a 'delete' button" do
        expect(page).to have_button("Delete")
      end
    end

    # * EDIT / UPDATE
    context "'edit'", js: true do
      before do
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
    context "'destroy'", js: true do
      before do
        visit user_path(@user)
        click_on "Delete"
      end

      context "clicking on delete button" do
        scenario "opens a destroy modal" do
          expect(page).to have_css("#destroyModal")
        end

        scenario "shows confirmation heading" do
          within(".modal-header") do
            expect(page).to have_css("h1", text: "Confirm Deletion")
          end
        end

        scenario "shows confirmation message" do
          within(".modal-body") do
            expect(page).to have_content("Are you sure you want to delete User: #{@user.name}? This action cannot be undone.")
          end
        end

        scenario "show action buttons" do
          within(".modal-footer") do
            expect(page).to have_css(".btn-secondary", text: "Cancel")
            expect(page).to have_css(".btn-primary", text: "Yes, delete it!")
          end
        end
      end

      context "after clicking 'Yes, delete it!' button" do
        before do
          click_on "Yes, delete it!"
        end

        scenario "returns to root path" do
          expect(current_path).to eql login_path
        end

        scenario "shows success flash message" do
          expect(page).to have_content("User deleted successfully")
        end
      end
    end
  end

  # * NOT ACCESSED by Viewers
  context "'Viewer' will NOT render template" do
    before do
      @viewer = FactoryBot.create(:viewer_user)
      page.set_rack_session(user_id: @viewer.id)
    end

    scenario "'new'" do
      visit new_user_path
      expect(current_path).to eq root_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'show'" do
      visit user_path(@viewer)
      expect(current_path).to eq root_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'edit'" do
      visit edit_user_path(@viewer)
      expect(current_path).to eq root_path
      expect(page).to have_content "Not Authorized!"
    end
  end

  # * ONLY Admin types
  context "'Admin' WILL render template" do
    before do
      @admin = FactoryBot.create(:admin_user)
      page.set_rack_session(user_id: @admin.id)
      visit root_path
    end

    # * NEW
    context "'new' shoould have" do
      before do
        click_on "Admin"
        click_on "New User"
      end

      scenario "a correct url and a heading" do
        expect(current_path).to eql new_user_path
        expect(page).to have_css("h2", text: "New User")
      end
    end

    #  * CREATE
    context "creating a new user" do
      before do
        click_on "Admin"
        click_on "New User"
      end

      scenario "be able to create with valid values" do
        attributes = FactoryBot.attributes_for(:user).except(:role)

        attributes.each do |k, v|
          fill_in "user_#{k}", with: v
        end

        select User.roles.keys.sample.to_s.titleize, from: :user_role

        click_button "Create User"

        expect(current_path).to eql users_path
        expect(page).to have_content("User created successfully")
      end

      scenario "should NOT be able to create with invalid values" do
        attributes = FactoryBot.attributes_for(:invalid_user).except(:role)

        attributes.each do |k, v|
          fill_in "user_#{k}", with: v
        end

        select User.roles.keys.sample.to_s.titleize, from: :user_role

        click_button "Create User"

        expect(page).to have_content("Please review the problems below:")
        expect(page).to have_content("Password confirmation doesn't match Password")
      end
    end

    # * INDEX
    context "'index' should have" do
      before do
        @users = FactoryBot.create_list(:user, 3)
        visit users_path
      end

      scenario "a heading" do
        expect(page).to have_css("h2", text: "All Users")
      end

      scenario "Name & role of all Users" do
        @users.each do |user|
          expect(page).to have_content(user.name)
        end
      end

      scenario "NOT show current admin details" do
        expect(page).to have_no_content(@admin.name)
      end

      scenario "a button 'name' that routes to user:show page after clicking it" do
        @users.each do |user|
          expect(page).to have_content(user.name)

          click_on user.name.to_s
          expect(current_path).to eql user_path(user)
          visit users_path
        end
      end
    end
  end

  # * NOT ACCESSED by 'member' & 'viewer'
  context "'Member' & 'viewer' will NOT render template" do
    before do
      @user = FactoryBot.create(:user_other_than_admin)
      page.set_rack_session(user_id: @user.id)
      visit root_path
    end

    # * NEW
    scenario "'new'" do
      visit new_user_path
      expect(current_path).to eq root_path
      expect(page).to have_content "Not Authorized!"
    end

    # * INDEX
    scenario "'index'" do
      visit users_path
      expect(current_path).to eq root_path
      expect(page).to have_content "Not Authorized!"
    end
  end
end
