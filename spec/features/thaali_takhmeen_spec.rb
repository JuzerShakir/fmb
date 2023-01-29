require "rails_helper"

RSpec.describe "ThaaliTakhmeen features" do
    before do
        @user = FactoryBot.create(:user)
        page.set_rack_session(user_id: @user.id)
        visit root_path

        @sabeel = FactoryBot.create(:sabeel)
    end

    context "'Create Takhmeen' link to be" do
        scenario "visible if sabeel is NOT taking thaali for current year" do
            thaali = FactoryBot.create(:previous_takhmeen, sabeel_id: @sabeel.id)

            visit sabeel_path(@sabeel)

            expect(page).to have_button('New Takhmeen')
        end

        scenario "NOT visible if sabeel is ALREADY taking thaali for current year" do
            thaali = FactoryBot.create(:active_takhmeen, sabeel_id: @sabeel.id)

            visit sabeel_path(@sabeel)

            expect(page).to have_no_link('New Takhmeen')
        end
    end

    # * NEW
    context "'new'" do
        before do
            visit new_sabeel_takhmeen_path(@sabeel)
        end

        scenario "should have correct URL" do
            expect(current_path).to eql new_sabeel_takhmeen_path(@sabeel)
        end

        scenario "should have a heading" do
            expect(page).to have_css('h2', text: "New Thaali Takhmeen")
        end

        context "should be able to fill the takhmeen details for the sabeel" do
            before do
                visit root_path
            end

            scenario "who HAS NOT taken thaali in previous year" do
                thaali = FactoryBot.build(:active_takhmeen, sabeel_id: @sabeel.id)
                visit new_sabeel_takhmeen_path(@sabeel)

                fill_in "thaali_takhmeen_number", with: "#{thaali.number}"
                fill_in "thaali_takhmeen_total", with: "#{thaali.total}"
                select thaali.size.to_s.titleize, from: :thaali_takhmeen_size
            end

            # scenario "who HAS taken thaali in previous year" do
            #     thaali = FactoryBot.build(:previous_takhmeen, sabeel_id: @sabeel.id)
            #     visit new_sabeel_takhmeen_path(@sabeel)

            #     within(".thaali_takhmeen_number") do
            #         expect(page).to have_content("#{thaali.number}")
            #     end

            #     within(".thaali_takhmeen_size") do
            #         expect(page).to have_content("#{thaali.size.to_s.titleize}")
            #     end

            #     fill_in "thaali_takhmeen_total", with: "#{thaali.total}"
            # end
        end

        scenario "should have 'Create' button" do
            expect(page).to have_button("Create Thaali takhmeen")
            click_on "Create Thaali takhmeen"
        end
    end

    #  * CREATE
    context "'create'" do
        before do
            @thaali = FactoryBot.build(:active_takhmeen, sabeel_id: @sabeel.id)
            visit new_sabeel_takhmeen_path(@sabeel)

            fill_in "thaali_takhmeen_number", with: "#{@thaali.number}"
            fill_in "thaali_takhmeen_total", with: "#{@thaali.total}"
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

    # * INDEX
    context "'index'", js: true do
        before do
            @thaalis = FactoryBot.create_list(:active_takhmeen, 3)
            visit root_path
        end

        scenario "should have a heading" do
            expect(page).to have_css('h2', text: "Thaali Takhmeens #{$active_takhmeen}")
        end

        scenario "should have a link to thaali_number button that renders takhmeen:show page after clicking it" do
            @thaalis.each do |thaali|
                number = thaali.number
                expect(page).to have_content("#{number}")

                click_button "#{number}"
                expect(current_path).to eql takhmeen_path(thaali)
                page.driver.go_back
            end
        end

        scenario "should show 'hof_name', 'address' & 'is_complete' of all thaalis" do
            @thaalis.each do |thaali|
                sabeel = thaali.sabeel
                expect(page).to have_content("#{sabeel.hof_name}")
                if thaali.is_complete
                    expect(page).to have_css('.fa-check')
                else
                    expect(page).to have_css('.fa-xmark')
                end
            end
        end
    end

    #  * EDIT
    context "'editing'" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
            visit takhmeen_path(@thaali)
        end
        scenario "should BE able to update with valid values" do
            click_on "Edit"
            expect(current_path).to eql edit_takhmeen_path(@thaali)

            fill_in "thaali_takhmeen_number", with: "#{Random.rand(1..400)}"
            click_on "Update Thaali takhmeen"

            expect(page).to have_content("Thaali Takhmeen updated successfully")
        end
    end

    #  * SHOW
    context "'show'" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        end

        scenario "should show all details of the Takhmeen" do
            visit takhmeen_path(@thaali)

            atrbs = FactoryBot.attributes_for(:thaali_takhmeen).keys - [:size, :is_complete]
            atrbs.each do | attrb |
                expect(page).to have_content("#{@thaali.send(attrb)}")
            end

            expect(page).to have_content("#{@thaali.size.humanize}")

            if @thaali.is_complete
                expect(page).to have_css('.fa-check')
            else
                expect(page).to have_css('.fa-xmark')
            end
        end

        context "transaction details of a takhmeen" do
            context "if it exists" do
                before do
                    2.times do |i|
                        FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali.id)
                    end
                    @transactions = @thaali.transactions
                    visit takhmeen_path(@thaali)
                end

                scenario "should show total number of transactions" do
                    expect(page).to have_content("Total number of Transactions: #{@transactions.count}")
                end

                scenario "should show 'recipe_no', 'amount', 'on_date' values" do
                    @transactions.each do |trans|
                        expect(page).to have_content(trans.recipe_no)
                        expect(page).to have_content(trans.amount)
                        expect(page).to have_content(time_ago_in_words(trans.on_date))
                    end
                end

                scenario "should be able to visit transaction show page after clicking on the recipe_no" do
                    @transactions.each do | trans |
                        recipe_no = trans.recipe_no
                        click_button "#{recipe_no}"
                        expect(current_path).to eql transaction_path(trans)
                        visit takhmeen_path(@thaali)
                    end
                end
            end
        end
    end

    # * DELETE
    scenario "'delete'" do
        @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        visit takhmeen_path(@thaali)
        expect(page).to have_button("Delete")

        click_on "Delete"
        click_on "Yes, delete it!"

        expect(current_path).to eql sabeel_path(@sabeel)
        expect(page).to have_content("Thaali Takhmeen destroyed successfully")
    end

    #* COMPLETE
    context "'complete'" do
        before do
            @thaalis = FactoryBot.create_list(:active_completed_takhmeens, 3)
            visit takhmeens_complete_path($active_takhmeen)
        end

        scenario "should have a header" do
            expect(page).to have_css("h2", text: "Completed Takhmeens #{$active_takhmeen}")
        end

        context "should list all the Completed Takhmeens details", js: true do
            scenario "such as 'thaali_number', 'name', 'address' & 'is_complete'" do
                @thaalis.each do |thaali|
                    expect(page).to have_content("#{thaali.number}")
                    sabeel = thaali.sabeel
                    expect(page).to have_content("#{sabeel.hof_name}")
                    if thaali.is_complete
                        expect(page).to have_css('.fa-check')
                    else
                        expect(page).to have_css('.fa-xmark')
                    end
                end
            end

            scenario "be able to visit thaali show page after clicking on the thaali_number" do
                @thaalis.each do | thaali |
                    click_button "#{thaali.number}"
                    expect(current_path).to eql takhmeen_path(thaali)
                    visit takhmeens_complete_path($active_takhmeen)
                end
            end
        end
    end

    #* PENDING
    context "'pending'" do
        before do
            @thaalis = FactoryBot.create_list(:active_takhmeen, 3)
            visit takhmeens_pending_path($active_takhmeen)
        end

        scenario "should have a header" do
            expect(page).to have_css("h2", text: "Pending Takhmeens #{$active_takhmeen}")
        end

        context "should list all the Pending Takhmeens details", js: true do
            scenario "such as 'thaali_number', 'name', 'address' & 'is_complete'" do
                @thaalis.each do |thaali|
                    expect(page).to have_content("#{thaali.number}")
                    sabeel = thaali.sabeel
                    expect(page).to have_content("#{sabeel.hof_name}")
                    if thaali.is_complete
                        expect(page).to have_css('.fa-check')
                    else
                        expect(page).to have_css('.fa-xmark')
                    end
                end
            end

            scenario "be able to visit thaali show page after clicking on the thaali_number" do
                @thaalis.each do | thaali |
                    click_button "#{thaali.number}"
                    expect(current_path).to eql takhmeen_path(thaali)
                    visit takhmeens_pending_path($active_takhmeen)
                end
            end
        end
    end

    # * ALL
    context "'all'" do
        before do
            @thaalis = FactoryBot.create_list(:previous_takhmeen, 3)
            visit takhmeens_all_path($prev_takhmeen)
        end

        scenario "should have a header" do
            expect(page).to have_css("h2", text: "Thaali Takhmeens #{$prev_takhmeen}")
        end

        context "should list all the Takhmeens details for the year in the params", js: true do
            scenario "such as 'thaali_number', 'name', 'address' & 'is_complete'" do
                @thaalis.each do |thaali|
                    expect(page).to have_content("#{thaali.number}")
                    sabeel = thaali.sabeel
                    expect(page).to have_content("#{sabeel.hof_name}")
                    if thaali.is_complete
                        expect(page).to have_css('.fa-check')
                    else
                        expect(page).to have_css('.fa-xmark')
                    end
                end
            end

            scenario "should be able to visit thaali show page after clicking on the thaali_number" do
                @thaalis.each do | thaali |
                    click_button "#{thaali.number}"
                    expect(current_path).to eql takhmeen_path(thaali)
                    visit takhmeens_all_path($prev_takhmeen)
                end
            end
        end
    end

    # * Statistics
    context "'statistics'" do
        before do
            @sizes = ThaaliTakhmeen.sizes.keys
        end

        scenario "should have a header" do
            visit takhmeens_stats_path
            expect(page).to have_css("h2", text: "Takhmeen Statistics")
        end

        context "for all the years" do
            context "show details of current year" do
                before do
                    @sizes.each do |size|
                        FactoryBot.create(:active_takhmeen, size: size)
                    end
                    FactoryBot.create_list(:active_completed_takhmeens, 2)
                    visit takhmeens_stats_path
                end

                scenario "title" do
                    within("div##{$active_takhmeen}") do
                        expect(page).to have_css("h3", text: $active_takhmeen)
                    end
                end

                scenario "total amount" do
                    within("div##{$active_takhmeen}") do
                        total = ThaaliTakhmeen.in_the_year($active_takhmeen).pluck(:total).sum
                        expect(page).to have_content(number_with_delimiter(total))
                    end
                end

                scenario "Balance amount" do
                    within("div##{$active_takhmeen}") do
                        balance = ThaaliTakhmeen.in_the_year($active_takhmeen).pluck(:balance).sum
                        expect(page).to have_content(number_with_delimiter(balance))
                    end
                end

                scenario "completed takhmeens" do
                    within("div##{$active_takhmeen}") do
                        expect(page).to have_selector(:link_or_button, "Complete: #{ThaaliTakhmeen.completed_year($active_takhmeen).count}")
                    end
                end

                scenario "should redirect to completed takhmeens page by clicking 'complete' button" do
                    within("div##{$active_takhmeen}") do
                        click_on "Complete: "
                        expect(current_path).to eql(takhmeens_complete_path($active_takhmeen))
                    end
                end

                scenario "should redirect to pending takhmeens page by clicking 'pending' button" do
                    within("div##{$active_takhmeen}") do
                        click_on "Pending: "
                        expect(current_path).to eql(takhmeens_pending_path($active_takhmeen))
                    end
                end

                scenario "pending takhmeens" do
                    within("div##{$active_takhmeen}") do
                        expect(page).to have_selector(:link_or_button, "Pending: #{ThaaliTakhmeen.pending_year($active_takhmeen).count}")
                    end
                end

                scenario "total number of thaali sizes" do
                    within("div##{$active_takhmeen}") do
                        @sizes.each do |size|
                            expect(page).to have_content("#{size.humanize}: #{ThaaliTakhmeen.in_the_year($active_takhmeen).send(size).count}")
                        end
                    end
                end

                scenario "total no. of takhmeens" do
                    within("div##{$active_takhmeen}") do
                        expect(page).to have_selector(:link_or_button, "Total Takhmeens: #{ThaaliTakhmeen.in_the_year($active_takhmeen).count}")
                    end
                end
            end
        end
    end
end