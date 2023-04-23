require "rails_helper"

RSpec.describe "ThaaliTakhmeen accessed by users who are 👉" do
  before do
    @sabeel = FactoryBot.create(:sabeel)
  end

  # * NON-LOGGED-IN users
  context "not-logged-in will NOT render template" do
    before do
      @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
    end

    scenario "'new'" do
      visit new_sabeel_takhmeen_path(@sabeel)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'show'" do
      visit takhmeen_path(@thaali)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'edit'" do
      visit edit_takhmeen_path(@thaali)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'index'" do
      visit root_path
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'stats'" do
      visit takhmeens_stats_path
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'complete'" do
      year = CURR_YR
      visit thaali_takhmeens_complete_path(year)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'pending'" do
      year = CURR_YR
      visit thaali_takhmeens_pending_path(year)
      expect(current_path).to eq login_path
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'all'" do
      year = CURR_YR
      visit thaali_takhmeens_pending_path(year)
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

    #  * SHOW
    context "'show', should have" do
      before do
        @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        visit takhmeen_path(@thaali)
      end

      scenario "details of a ThaaliTakhmeen" do
        atrbs = FactoryBot.attributes_for(:thaali_takhmeen).keys - %i[size is_complete]
        atrbs.each do |attrb|
          expect(page).to have_content(@thaali.send(attrb))
        end

        expect(page).to have_content(@thaali.size.humanize)

        if @thaali.is_complete
          expect(page).to have_css(".fa-check")
        else
          expect(page).to have_css(".fa-xmark")
        end
      end

      scenario "an edit link" do
        expect(page).to have_link("Edit")
      end

      scenario "a 'delete' link" do
        expect(page).to have_button("Delete")
      end

      context "transaction details such as - " do
        before do
          visit root_path
          2.times do
            max = @thaali.balance / 3
            amount = Random.rand(1..max)
            FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali.id, amount:)
          end
          @transactions = @thaali.transactions
          visit takhmeen_path(@thaali)
        end

        scenario "total number of transactions" do
          expect(page).to have_content("Total number of Transactions: #{@transactions.count}")
        end

        scenario "'recipe_no', 'amount', 'date' values" do
          @transactions.each do |trans|
            expect(page).to have_content(trans.recipe_no)
            expect(page).to have_content(trans.amount)
            expect(page).to have_content(time_ago_in_words(trans.date))
          end
        end

        scenario "'recipe_no' button that routes to transaction 'show' page" do
          @transactions.each do |trans|
            recipe_no = trans.recipe_no
            click_button recipe_no.to_s
            expect(current_path).to eql transaction_path(trans)
            visit takhmeen_path(@thaali)
          end
        end
      end
    end

    # * INDEX
    context "'index' should show", js: true do
      before do
        @thaalis = FactoryBot.create_list(:active_takhmeen, 3)
        visit root_path
      end

      scenario "a heading" do
        expect(page).to have_css("h2", text: "Takhmeens in #{CURR_YR}")
      end

      scenario "a thaali_number button that routes to takhmeen:show page" do
        @thaalis.each do |thaali|
          number = thaali.number
          expect(page).to have_content(number)

          click_button number.to_s
          expect(current_path).to eql takhmeen_path(thaali)
          page.driver.go_back
        end
      end

      scenario "'name', 'address' & 'is_complete' of all thaalis" do
        @thaalis.each do |thaali|
          sabeel = thaali.sabeel
          expect(page).to have_content(sabeel.name)
          if thaali.is_complete
            expect(page).to have_css(".fa-check")
          else
            expect(page).to have_css(".fa-xmark")
          end
        end
      end

      context "search that returns thaalis with the" do
        scenario "thaali number searched for" do
          searched = @thaalis.first.number
          un_searched = @thaalis.last.number

          fill_in "q_number_cont", with: searched

          within("div#all-thaalis") do
            expect(page).to have_content(searched)
            expect(page).not_to have_content(un_searched)
          end
        end
      end
    end

    # * COMPLETE
    context "'complete' should show" do
      before do
        @thaalis = FactoryBot.create_list(:active_completed_takhmeens, 3)
        visit thaali_takhmeens_complete_path(CURR_YR)
      end

      scenario "a header" do
        expect(page).to have_css("h2", text: "Completed Takhmeens in #{CURR_YR}")
      end

      context "details of those ThaaliTakhmeens whose total amount is fully paid for the given year, such as - ",
        js: true do
        scenario "'number', 'name', 'address' & 'is_complete' attributes" do
          @thaalis.each do |thaali|
            expect(page).to have_content(thaali.number)
            sabeel = thaali.sabeel
            expect(page).to have_content(sabeel.name)
            if thaali.is_complete
              expect(page).to have_css(".fa-check")
            else
              expect(page).to have_css(".fa-xmark")
            end
          end
        end

        scenario "'number' button that routes to the thaali 'show' page" do
          @thaalis.each do |thaali|
            click_button thaali.number.to_s
            expect(current_path).to eql takhmeen_path(thaali)
            visit thaali_takhmeens_complete_path(CURR_YR)
          end
        end
      end
    end

    # * PENDING
    context "'pending' should show" do
      before do
        @thaalis = FactoryBot.create_list(:active_takhmeen, 3)
        visit thaali_takhmeens_pending_path(CURR_YR)
      end

      scenario "a header" do
        expect(page).to have_css("h2", text: "Pending Takhmeens in #{CURR_YR}")
      end

      context "details of those thaalis whose HAS balance amount for the given year such as -",
        js: true do
        scenario "'number', 'name', 'address' & 'is_complete' attributes" do
          @thaalis.each do |thaali|
            expect(page).to have_content(thaali.number)
            sabeel = thaali.sabeel
            expect(page).to have_content(sabeel.name)
            if thaali.is_complete
              expect(page).to have_css(".fa-check")
            else
              expect(page).to have_css(".fa-xmark")
            end
          end
        end

        scenario "'number' button that routes to the thaali 'show' page" do
          @thaalis.each do |thaali|
            click_button thaali.number.to_s
            expect(current_path).to eql takhmeen_path(thaali)
            visit thaali_takhmeens_pending_path(CURR_YR)
          end
        end
      end
    end

    # * ALL
    context "'all' should show" do
      before do
        @thaalis = FactoryBot.create_list(:previous_takhmeen, 3)
        visit thaali_takhmeens_all_path(PREV_YR)
      end

      scenario "a header" do
        expect(page).to have_css("h2", text: "Takhmeens in #{PREV_YR}")
      end

      context "details of all ThaaliTakhmeen for the given year, such as - ", js: true do
        scenario "'number', 'name', 'address' & 'is_complete' attributes" do
          @thaalis.each do |thaali|
            expect(page).to have_content(thaali.number)
            sabeel = thaali.sabeel
            expect(page).to have_content(sabeel.name)
            if thaali.is_complete
              expect(page).to have_css(".fa-check")
            else
              expect(page).to have_css(".fa-xmark")
            end
          end
        end

        scenario "'number' button that routes to the thaali 'show' page" do
          @thaalis.each do |thaali|
            click_button thaali.number.to_s
            expect(current_path).to eql takhmeen_path(thaali)
            visit thaali_takhmeens_all_path(PREV_YR)
          end
        end
      end
    end

    # * Statistics
    context "'statistics' should show" do
      before do
        @sizes = ThaaliTakhmeen.sizes.keys
      end

      scenario "a header" do
        visit takhmeens_stats_path
        expect(page).to have_css("h2", text: "Takhmeen Statistics")
      end

      context "following statistics for all the years, such as - " do
        before do
          @sizes.each do |size|
            FactoryBot.create(:active_takhmeen, size:)
          end
          FactoryBot.create_list(:active_completed_takhmeens, 2)
          visit takhmeens_stats_path
        end

        scenario "title (year)" do
          within("div##{CURR_YR}") do
            expect(page).to have_css("h3", text: CURR_YR)
          end
        end

        scenario "total Takhmeen amount" do
          within("div##{CURR_YR}") do
            total = ThaaliTakhmeen.in_the_year(CURR_YR).pluck(:total).sum
            expect(page).to have_content(number_with_delimiter(total))
          end
        end

        scenario "total Balance amount" do
          within("div##{CURR_YR}") do
            balance = ThaaliTakhmeen.in_the_year(CURR_YR).pluck(:balance).sum
            expect(page).to have_content(number_with_delimiter(balance))
          end
        end

        scenario "total completed takhmeens" do
          within("div##{CURR_YR}") do
            expect(page).to have_selector(:link_or_button,
              "Complete: #{ThaaliTakhmeen.completed_year(CURR_YR).count}")
          end
        end

        scenario "'Complete' button that routes to 'complete' template" do
          within("div##{CURR_YR}") do
            click_on "Complete: "
            expect(current_path).to eql(thaali_takhmeens_complete_path(CURR_YR))
          end
        end

        scenario "total pending takhmeens" do
          within("div##{CURR_YR}") do
            expect(page).to have_selector(:link_or_button,
              "Pending: #{ThaaliTakhmeen.pending_year(CURR_YR).count}")
          end
        end

        scenario "'Pending' button that routes to 'pending' template" do
          within("div##{CURR_YR}") do
            click_on "Pending: "
            expect(current_path).to eql(thaali_takhmeens_pending_path(CURR_YR))
          end
        end

        scenario "total thaalis for each size" do
          within("div##{CURR_YR}") do
            @sizes.each do |size|
              expect(page).to have_content("#{size.humanize}: #{ThaaliTakhmeen.in_the_year(CURR_YR).send(size).count}")
            end
          end
        end

        scenario "total takhmeens for the year" do
          within("div##{CURR_YR}") do
            expect(page).to have_selector(:link_or_button,
              "Total Takhmeens: #{ThaaliTakhmeen.in_the_year(CURR_YR).count}")
          end
        end
      end
    end
  end

  # * ONLY Admins & Members
  context "'Admin' & 'Member' WILL render template" do
    before do
      @user = FactoryBot.create(:user_other_than_viewer)
      page.set_rack_session(user_id: @user.id)
      visit root_path
    end

    # * NEW
    context "'new' should show" do
      scenario "correct URL" do
        visit sabeel_path(@sabeel)
        click_button "New Takhmeen"

        expect(current_path).to eql new_sabeel_takhmeen_path(@sabeel)
      end

      scenario "a heading" do
        visit new_sabeel_takhmeen_path(@sabeel)
        expect(page).to have_css("h2", text: "New Thaali Takhmeen")
      end

      context "a form to fill takhmeen details of a sabeel" do
        before do
          visit root_path
        end

        scenario "who HAS NOT taken thaali in previous year" do
          thaali = FactoryBot.build(:active_takhmeen, sabeel_id: @sabeel.id)
          visit new_sabeel_takhmeen_path(@sabeel)

          fill_in "thaali_takhmeen_number", with: thaali.number
          fill_in "thaali_takhmeen_total", with: thaali.total
          select thaali.size.to_s.titleize, from: :thaali_takhmeen_size
        end

        # FIXME: unable to show existing number & size property in the test
        # scenario "who HAS taken thaali in previous year" do
        #     thaali = FactoryBot.build(:previous_takhmeen, sabeel_id: @sabeel.id)
        #     visit new_sabeel_takhmeen_path(@sabeel)

        #     within(".thaali_takhmeen_number") do
        #         expect(page).to have_content(thaali.number)
        #     end

        #     within(".thaali_takhmeen_size") do
        #         expect(page).to have_content("#{thaali.size.to_s.titleize}")
        #     end

        #     fill_in "thaali_takhmeen_total", with: "#{thaali.total}"
        # end
      end

      scenario "a 'Create' button" do
        visit new_sabeel_takhmeen_path(@sabeel)
        expect(page).to have_button("Create Thaali takhmeen")
      end
    end

    #  * CREATE
    context "'create' action" do
      before do
        @thaali = FactoryBot.build(:active_takhmeen, sabeel_id: @sabeel.id)
        visit new_sabeel_takhmeen_path(@sabeel)

        fill_in "thaali_takhmeen_number", with: @thaali.number
        fill_in "thaali_takhmeen_total", with: @thaali.total
      end

      scenario "should BE able to create with valid values" do
        select @thaali.size.to_s.titleize, from: :thaali_takhmeen_size

        click_button "Create Thaali takhmeen"

        thaali_takhmeen = ThaaliTakhmeen.last
        expect(current_path).to eql takhmeen_path(thaali_takhmeen)
        expect(page).to have_content("Thaali Takhmeen created successfully")
      end

      scenario "should NOT BE able to create with invalid values" do
        click_button "Create Thaali takhmeen"

        # we haven't selected any size, which is required, hence thaali will not be saved
        expect(page).to have_content("Please review the problems below:")
        expect(page).to have_content("Size cannot be blank")
      end
    end

    #  * EDIT
    context "'editing' action" do
      before do
        @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        visit takhmeen_path(@thaali)
      end
      scenario "should BE able to update with valid values" do
        click_on "Edit"
        expect(current_path).to eql edit_takhmeen_path(@thaali)

        fill_in "thaali_takhmeen_number", with: Random.rand(1..400)
        click_on "Update Thaali takhmeen"

        expect(page).to have_content("Thaali Takhmeen updated successfully")
      end
    end

    # * DELETE
    context "'deleting' action", js: true do
      before do
        @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        visit takhmeen_path(@thaali)
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
            expect(page).to have_content("Are you sure you want to delete Thaali no: #{@thaali.number}? This action cannot be undone.")
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
          expect(current_path).to eql sabeel_path(@sabeel)
        end

        scenario "shows success flash message" do
          expect(page).to have_content("Thaali Takhmeen destroyed successfully")
        end
      end
    end
  end

  # * NOT ACCESSED by Viewers
  context "'Viewer' will NOT render template" do
    before do
      @viewer = FactoryBot.create(:viewer_user)
      page.set_rack_session(user_id: @viewer.id)
      @thaali = FactoryBot.create(:previous_takhmeen, sabeel_id: @sabeel.id)
      visit takhmeen_path(@thaali)
    end

    scenario "'new'" do
      visit sabeel_path(@sabeel)
      click_on "New Takhmeen"
      expect(current_path).to eq sabeel_path(@sabeel)
      expect(page).to have_content "Not Authorized!"
    end

    scenario "'edit'" do
      click_on "Edit"
      expect(current_path).to eq takhmeen_path(@thaali)
      expect(page).to have_content "Not Authorized!"
    end

    scenario "destroy" do
      click_on "Delete"
      click_on "Yes, delete it!"
      expect(current_path).to eq takhmeen_path(@thaali)
      expect(page).to have_content "Not Authorized!"
    end
  end
end
