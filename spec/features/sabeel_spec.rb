require "rails_helper"

RSpec.describe "Sabeel accessed by users who are 👉" do
  before do
    @sabeel = FactoryBot.create(:sabeel)
  end

  # * NON-LOGGED-IN users
  context "not-logged-in will NOT render template" do
    scenario "'new'" do
      visit new_sabeel_path
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'show'" do
      visit sabeel_path(@sabeel)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'edit'" do
      visit edit_sabeel_path(@sabeel)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'index'" do
      visit sabeels_path
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'stats'" do
      visit stats_sabeels_path
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'active'" do
      apt = Sabeel.apartments.keys.sample
      visit sabeels_active_path(apt)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'inactive'" do
      apt = Sabeel.apartments.keys.sample
      visit sabeels_inactive_path(apt)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end
  end

  # * ALL user types
  context "logged-in WILL render template" do
    before do
      @user = FactoryBot.create(:user)
      page.set_rack_session(user_id: @user.id)
      visit root_path
    end

    # * SHOW
    context "'show' should have" do
      before do
        visit sabeel_path(@sabeel)
      end

      scenario "correct URL" do
        expect(current_path).to eq sabeel_path(@sabeel)
      end

      scenario "sabeel details" do
        attrbs = FactoryBot.attributes_for(:sabeel).except!(:apartment, :flat_no)

        attrbs.keys.each do |attrb|
          expect(page).to have_content(@sabeel.send(attrb).to_s)
        end
      end

      scenario "an edit link" do
        expect(page).to have_link("Edit")
      end

      scenario "a 'delete' link" do
        expect(page).to have_button("Delete")
      end

      scenario "a 'New Takhmeen' button if sabeel is NOT actively taking thaali" do
        FactoryBot.create(:previous_takhmeen, sabeel_id: @sabeel.id)
        visit sabeel_path(@sabeel)

        expect(page).to have_button("New Takhmeen")
      end

      scenario "NO 'New Takhmeen' button if sabeel IS ACTIVELY taking thaali" do
        FactoryBot.create(:active_takhmeen, sabeel_id: @sabeel.id)
        visit sabeel_path(@sabeel)

        expect(page).to have_no_button("New Takhmeen")
      end

      context "takhmeen details, such as - " do
        before do
          2.times do |i|
            FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id, year: CURR_YR - i)
          end
          visit sabeel_path(@sabeel)
          @thaalis = @sabeel.thaali_takhmeens
        end

        scenario "total number of takhmeens" do
          expect(page).to have_content("Total number of Takhmeens: #{@thaalis.count}")
        end

        scenario "'year', 'total', 'balance' attributes" do
          @thaalis.each do |thaali|
            expect(page).to have_content(thaali.year)
            expect(page).to have_content(number_with_delimiter(thaali.total))
            expect(page).to have_content(number_with_delimiter(thaali.balance))
            if thaali.is_complete
              expect(page).to have_css(".fa-check")
            else
              expect(page).to have_css(".fa-xmark")
            end
          end
        end

        scenario "'year' button that routes to thaali show page" do
          @thaalis.each do |thaali|
            year = thaali.year
            click_button year.to_s
            expect(current_path).to eql takhmeen_path(thaali)
            visit sabeel_path(@sabeel)
          end
        end
      end
    end

    # * INDEX
    context "'index' should have", js: true do
      before do
        @sabeels = FactoryBot.create_list(:sabeel, 3)
        visit sabeels_path
      end

      scenario "a correct URL" do
        expect(current_path).to eq sabeels_path
      end

      scenario "a heading" do
        expect(page).to have_css("h2", text: "Sabeels")
      end

      scenario "a 'ITS' button that routes to thaali show page" do
        @sabeels.each do |sabeel|
          its = sabeel.its
          expect(page).to have_content(its)

          click_button its.to_s
          expect(current_path).to eql sabeel_path(its)
          page.driver.go_back
        end
      end

      scenario "'name' & 'apartment' of all sabeels" do
        @sabeels.each do |sabeel|
          expect(page).to have_content(sabeel.name)
          expect(page).to have_content(sabeel.apartment.titleize)
        end
      end

      context "search that returns sabeels with the" do
        scenario "ITS number searched for" do
          searched_its = @sabeels.first.its
          un_searched_its = @sabeels.last.its

          fill_in "q_name_or_its_cont", with: searched_its

          within("div#all-sabeels") do
            expect(page).to have_content(searched_its)
            expect(page).not_to have_content(un_searched_its)
          end
        end

        scenario "HOF name searched for" do
          searched_name = @sabeels.first.name
          un_searched_name = @sabeels.last.name

          fill_in "q_name_or_its_cont", with: searched_name

          within("div#all-sabeels") do
            expect(page).to have_content(searched_name)
            expect(page).not_to have_content(un_searched_name)
          end
        end
      end
    end

    # * ACTIVE
    context "'active' should have", js: true do
      before do
        @apt = Sabeel.apartments.keys.sample
        @sabeels = FactoryBot.create_list(:sabeel, 3, apartment: @apt)
        @sabeels.each do |sabeel|
          FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id)
        end
        visit sabeels_active_path(@apt)
      end

      scenario "a correct URL" do
        expect(current_path).to eq sabeels_active_path(@apt)
      end

      scenario "a header" do
        expect(page).to have_css("h2", text: "Active Sabeels: #{@apt.titleize}")
      end

      scenario "a button with font-awesome icon" do
        expect(page).to have_button("Generate PDF")
        expect(page).to have_css(".fa-file-pdf")
      end

      context "a button that generates PDF with - " do
        before do
          @pdf_window = window_opened_by { click_on "Generate PDF" }
        end

        # FIXME: use another logic to wait the test until the header appears
        scenario "a header" do
          within_window @pdf_window do
            # for the test to pass in github actions
            sleep 5
            expect(page).to have_content("#{@apt.titleize} - #{CURR_YR}")
          end
        end

        scenario "details of such as 'flat_no', 'name', 'mobile', 'number' & 'size'" do
          within_window @pdf_window do
            @sabeels.each do |sabeel|
              expect(page).to have_content(sabeel.flat_no)
              expect(page).to have_content(sabeel.name)
              expect(page).to have_content(sabeel.mobile)
              thaali = sabeel.thaali_takhmeens.first
              expect(page).to have_content(thaali.number)
              expect(page).to have_content(thaali.size.humanize.chr)
            end
          end
        end
      end

      scenario "details of all active sabeels of an apartment such as 'flat_no', 'name', 'number' & 'size'" do
        @sabeels.each do |sabeel|
          expect(page).to have_content(sabeel.flat_no)
          expect(page).to have_content(sabeel.name)
          thaali = sabeel.thaali_takhmeens.first
          expect(page).to have_content(thaali.number)
          expect(page).to have_content(thaali.size.humanize.chr)
        end
      end

      scenario "'flat_no' button that routes to corresponding sabeel show page" do
        @sabeels.each do |sabeel|
          flat_no = sabeel.flat_no
          click_button flat_no.to_s
          expect(current_path).to eql sabeel_path(sabeel)
          visit sabeels_active_path(@apt)
        end
      end

      scenario "'number' button that routes to corresponding thaali show page" do
        @sabeels.each do |sabeel|
          thaali = sabeel.thaali_takhmeens.first
          click_button thaali.number.to_s
          expect(current_path).to eql takhmeen_path(thaali)
          visit sabeels_active_path(@apt)
        end
      end
    end

    # * INACTIVE
    context "'inactive' should have", js: true do
      before do
        @apt = Sabeel.apartments.keys.sample
        @sabeels = FactoryBot.create_list(:sabeel, 3, apartment: @apt)
        visit sabeels_inactive_path(@apt)
      end

      scenario "a correct URL" do
        expect(current_path).to eq sabeels_inactive_path(@apt)
      end

      scenario "a header" do
        expect(page).to have_css("h2", text: "Inactive Sabeels: #{@apt.titleize}")
      end

      scenario "all details of inactive sabeels of an apartment such as 'its' & 'name'" do
        @sabeels.each do |sabeel|
          expect(page).to have_content(sabeel.its)
          expect(page).to have_content(sabeel.name)
        end
      end
    end

    # * Statistics
    context "'statistics' should have" do
      before do
        @sizes = ThaaliTakhmeen.sizes.keys
        visit stats_sabeels_path
      end

      scenario "a correct URL" do
        expect(current_path).to eq stats_sabeels_path
      end

      scenario "a header" do
        expect(page).to have_css("h2", text: "Sabeel Statistics: #{CURR_YR}")
      end

      context "detials of Maimoon A, such as - " do
        before do
          @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "maimoon_a")
          @sabeels.first(3).each.with_index do |sabeel, i|
            FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
          end
          visit stats_sabeels_path
        end
        scenario "a title" do
          expect(page).to have_css("h3", text: "Maimoon A")
        end

        scenario "total number of active sabeels" do
          within("div#maimoon_a") do
            count = Sabeel.maimoon_a.active_takhmeen(CURR_YR).count
            expect(page).to have_selector(:link_or_button,
              "Active: #{count}")
          end
        end

        scenario "'active' button that routes to 'active' page" do
          within("div#maimoon_a") do
            click_on "Active: "
            expect(current_path).to eql(sabeels_active_path("maimoon_a"))
          end
        end

        scenario "'inactive' button that routes to 'inactive' page" do
          within("div#maimoon_a") do
            click_on "Inactive: "
            expect(current_path).to eql(sabeels_inactive_path("maimoon_a"))
          end
        end

        scenario "total number of inactive sabeels" do
          within("div#maimoon_a") do
            count = Sabeel.inactive_takhmeen("maimoon_a").count
            expect(page).to have_selector(:link_or_button, "Inactive: #{count}")
          end
        end

        scenario "total number of thaali sizes" do
          within("div#maimoon_a") do
            @sizes.each do |size|
              expect(page).to have_content("#{size.humanize}: #{Sabeel.maimoon_a.active_takhmeen(CURR_YR).with_the_size(size).count}")
            end
          end
        end
      end

      context "detials of Maimoon B, such as - " do
        before do
          @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "maimoon_b")
          @sabeels.first(3).each.with_index do |sabeel, i|
            FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
          end
          visit stats_sabeels_path
        end

        scenario "a title" do
          expect(page).to have_css("h3", text: "Maimoon B")
        end

        scenario "total number of active sabeels" do
          within("div#maimoon_b") do
            count = Sabeel.maimoon_b.active_takhmeen(CURR_YR).count
            expect(page).to have_selector(:link_or_button,
              "Active: #{count}")
          end
        end

        scenario "'active' button that routes to 'active' page" do
          within("div#maimoon_b") do
            click_on "Active: "
            expect(current_path).to eql(sabeels_active_path("maimoon_b"))
          end
        end

        scenario "'inactive' button that routes to 'inactive' page" do
          within("div#maimoon_b") do
            click_on "Inactive: "
            expect(current_path).to eql(sabeels_inactive_path("maimoon_b"))
          end
        end

        scenario "total number of inactive sabeels" do
          within("div#maimoon_b") do
            count = Sabeel.inactive_takhmeen("maimoon_b").count
            expect(page).to have_selector(:link_or_button, "Inactive: #{count}")
          end
        end

        scenario "total number of thaali sizes" do
          within("div#maimoon_b") do
            @sizes.each do |size|
              expect(page).to have_content("#{size.humanize}: #{Sabeel.maimoon_b.active_takhmeen(CURR_YR).with_the_size(size).count}")
            end
          end
        end
      end
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
    context "'new' should have" do
      scenario "a correct url & a heading" do
        click_on "Create Sabeel"
        expect(current_path).to eql new_sabeel_path
        expect(page).to have_css("h2", text: "New Sabeel")
      end
    end

    #  * CREATE
    context "creating action" do
      before do
        attributes = FactoryBot.attributes_for(:sabeel)
        @apt = attributes.extract!(:apartment)

        visit new_sabeel_path

        attributes.each do |k, v|
          fill_in "sabeel_#{k}",	with: v
        end
      end

      scenario "should be able to create with valid values" do
        select @apt.fetch(:apartment).titleize, from: :sabeel_apartment

        click_button "Create Sabeel"

        sabeel = Sabeel.last
        expect(current_path).to eql sabeel_path(sabeel)
        expect(page).to have_content("Sabeel created successfully")
      end

      scenario "should NOT be able to create with invalid values" do
        # we haven't selected any apartment, which is required, hence sabeel will not be saved

        click_button "Create Sabeel"

        expect(page).to have_content("Please review the problems below:")
        expect(page).to have_content("Apartment cannot be blank")
      end
    end

    # * DELETE
    context "'deleting' action", js: true do
      before do
        visit sabeel_path(@sabeel)
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
            expect(page).to have_content("Are you sure you want to delete Sabeel ITS no: #{@sabeel.its}? This action cannot be undone.")
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
          expect(current_path).to eql root_path("format=html")
        end

        scenario "shows success flash message" do
          expect(page).to have_content("Sabeel deleted successfully")
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
      visit new_sabeel_path
      expect(current_path).to eq root_path
      expect(page).to have_content "Not Authorized!"
    end

    # * DELETE
    scenario "destroy" do
      visit sabeel_path(@sabeel)
      click_on "Delete"
      click_on "Yes, delete it!"
      expect(current_path).to eq sabeel_path(@sabeel)
      expect(page).to have_content "Not Authorized!"
    end
  end

  # * ONLY Admins & Members
  context "'Admin' & 'Member' WIlL render template" do
    before do
      @user = FactoryBot.create(:user_other_than_viewer)
      page.set_rack_session(user_id: @user.id)
      visit root_path
    end

    # * EDIT
    context "'edit' should show" do
      before do
        visit edit_sabeel_path(@sabeel)
      end

      scenario "form fields of sabeel to update details with valid inputs" do
        fill_in "sabeel_mobile", with: Faker::Number.number(digits: 10)

        click_on "Update Sabeel"
        expect(current_path).to eql sabeel_path(@sabeel)
        expect(page).to have_content("Sabeel updated successfully")
      end
    end
  end

  # * NOT ACCESSED by Viewers
  context "'Viewer' will NOT render template" do
    before do
      @viewer = FactoryBot.create(:viewer_user)
      page.set_rack_session(user_id: @viewer.id)
      visit sabeel_path(@sabeel)
    end

    scenario "'edit'" do
      click_on "Edit"
      expect(current_path).to eq sabeel_path(@sabeel)
      expect(page).to have_content "Not Authorized!"
    end
  end
end
