require 'rails_helper'

RSpec.describe "Sabeel template" do
    before do
        @user = FactoryBot.create(:user)
        page.set_rack_session(user_id: @user.id)
        visit root_path

        @sabeel = FactoryBot.create(:sabeel)
    end

    # * NEW / CREATE
    context "'new'" do
        scenario "should have a correct url and a heading" do
            click_on "Create Sabeel"
            expect(current_path).to eql new_sabeel_path
            expect(page).to have_css('h2', text: "New Sabeel")
        end

        context "creating sabeel" do
            before do
                attributes = FactoryBot.attributes_for(:sabeel)
                @apt = attributes.extract!(:apartment)

                visit new_sabeel_path

                attributes.each do |k, v|
                    fill_in "sabeel_#{k}",	with: "#{v}"
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
    end

    # * INDEX
    context "'index'", js: true do
        before do
            @sabeels = FactoryBot.create_list(:sabeel, 3)
            visit all_sabeels_path
        end

        scenario "shows a heading" do
            expect(page).to have_css('h2', text: "Sabeels")
        end

        scenario "shows 'ITS' button that routes to thaali show page" do
            @sabeels.each do |sabeel|
                its = sabeel.its
                expect(page).to have_content("#{its}")

                click_button "#{its}"
                expect(current_path).to eql sabeel_path(its)
                page.driver.go_back
            end
        end

        scenario "shows 'hof_name' & 'apartment' of all sabeels" do
            @sabeels.each do |sabeel|
                expect(page).to have_content("#{sabeel.hof_name}")
                expect(page).to have_content("#{sabeel.apartment.titleize}")
            end
        end
    end

    # * SHOW
    context "'show'" do
        before do
            visit sabeel_path(@sabeel)
        end

        scenario "shows sabeel details" do
            attrbs = FactoryBot.attributes_for(:sabeel).except!(:apartment, :flat_no)

            attrbs.keys.each do | attrb |
                expect(page).to have_content("#{@sabeel.send(attrb)}")
            end
        end

        scenario "should have an edit link" do
            expect(page).to have_link("Edit")
        end

        scenario "should have a 'delete' link" do
            expect(page).to have_button('Delete')
        end

        context "'New Takhmeen' button to be" do
            scenario "shown if sabeel is NOT actively taking thaali" do
                thaali = FactoryBot.create(:previous_takhmeen, sabeel_id: @sabeel.id)
                visit sabeel_path(@sabeel)

                expect(page).to have_button('New Takhmeen')
            end

            scenario "NOT shown if sabeel IS ACTIVELY taking thaali" do
                thaali = FactoryBot.create(:active_takhmeen, sabeel_id: @sabeel.id)
                visit sabeel_path(@sabeel)

                expect(page).to have_no_button('New Takhmeen')
            end
        end

        context "shows takhmeen details of a sabeel such as - " do
            before do
                2.times do |i|
                    FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id, year: $active_takhmeen - i)
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
                    expect(page).to have_content(thaali.total)
                    expect(page).to have_content(thaali.balance)
                    if thaali.is_complete
                        expect(page).to have_css('.fa-check')
                    else
                        expect(page).to have_css('.fa-xmark')
                    end
                end
            end

            scenario "'year' button that routes to thaali show page" do
                @thaalis.each do | thaali |
                    year = thaali.year
                    click_button "#{year}"
                    expect(current_path).to eql takhmeen_path(thaali)
                    visit sabeel_path(@sabeel)
                end
            end
        end
    end

    # * EDIT
    context "'edit'" do
        before do
            visit edit_sabeel_path(@sabeel)
        end

        scenario "has form fields and updates details for valid inputs" do
            fill_in "sabeel_mobile", with: Faker::Number.number(digits: 10)

            click_on "Update Sabeel"
            expect(current_path).to eql sabeel_path(@sabeel)
            expect(page).to have_content("Sabeel updated successfully")
        end
    end

    # * DELETE
    scenario "Deleting a Sabeel" do
        visit sabeel_path(@sabeel)

        click_on "Delete"
        click_on "Yes, delete it!"

        expect(current_path).to eql root_path("format=html")
        expect(page).to have_content("Sabeel deleted successfully")
    end

    #* ACTIVE
    context "'active'", js: true do
        before do
            @apt = Sabeel.apartments.keys.sample
            @sabeels = FactoryBot.create_list(:sabeel, 3, apartment: @apt)
            @sabeels.each do |sabeel|
                FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id)
            end
            visit active_sabeels_path(@apt)
        end

        scenario "should show a header" do
            expect(page).to have_css("h2", text: "Active Sabeels: #{@apt.titleize}")
        end

        scenario "should have a button with font-awesome icon that renders pdf" do
            expect(page).to have_button('Generate PDF')
            expect(page).to have_css('.fa-file-pdf')
        end

        context "generates PDF with - " do
            before do
                @pdf_window = window_opened_by { click_on "Generate PDF" }
            end

            scenario "a header" do
                within_window @pdf_window do
                    expect(page).to have_content("#{@apt.titleize} - #{$active_takhmeen}")
                end
            end

            scenario "details of all sabeels such as 'flat_no', 'hof_name', 'mobile', 'number' & 'size'" do
                within_window @pdf_window do
                    @sabeels.each do |sabeel|
                        expect(page).to have_content("#{sabeel.flat_no}")
                        expect(page).to have_content("#{sabeel.hof_name}")
                        expect(page).to have_content("#{sabeel.mobile}")
                        thaali = sabeel.thaali_takhmeens.first
                        expect(page).to have_content("#{thaali.number}")
                        expect(page).to have_content("#{thaali.size.humanize.chr}")
                    end
                end
            end
        end

        scenario "shows details of all active sabeels of an apartment such as 'flat_no', 'hof_name', 'number' & 'size'" do
            @sabeels.each do |sabeel|
                expect(page).to have_content("#{sabeel.flat_no}")
                expect(page).to have_content("#{sabeel.hof_name}")
                thaali = sabeel.thaali_takhmeens.first
                expect(page).to have_content("#{thaali.number}")
                expect(page).to have_content("#{thaali.size.humanize.chr}")
            end
        end

        scenario "shows 'flat_no' button that routes to corresponding sabeel show page" do
            @sabeels.each do | sabeel |
                flat_no = sabeel.flat_no
                click_button "#{flat_no}"
                expect(current_path).to eql sabeel_path(sabeel)
                visit active_sabeels_path(@apt)
            end
        end

        scenario "shows 'number' button that routes to corresponding thaali show page" do
            @sabeels.each do | sabeel |
                thaali = sabeel.thaali_takhmeens.first
                click_button "#{thaali.number}"
                expect(current_path).to eql takhmeen_path(thaali)
                visit active_sabeels_path(@apt)
            end
        end
    end

    #* INACTIVE
    context "'inactive'", js: true do
        before do
            @apt = Sabeel.apartments.keys.sample
            @sabeels = FactoryBot.create_list(:sabeel, 3, apartment: @apt)
            visit inactive_sabeels_path(@apt)
        end

        scenario "should have a header" do
            expect(page).to have_css("h2", text: "Inactive Sabeels: #{@apt.titleize}")
        end

        scenario "shows all details of inactive sabeels of an apartment such as 'its', 'hof_name' & 'apartment'" do
            @sabeels.each do |sabeel|
                expect(page).to have_content("#{sabeel.its}")
                expect(page).to have_content("#{sabeel.hof_name}")
                expect(page).to have_content("#{sabeel.apartment.titleize}")
            end
        end
    end

    # * Statistics
    context "'statistics'" do
        before do
            @sizes = ThaaliTakhmeen.sizes.keys
        end

        scenario "should have a header" do
            visit stats_sabeels_path
            expect(page).to have_css("h2", text: "Sabeel Statistics: #{$active_takhmeen}")
        end

        context "for Maimoon A" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "maimoon_a")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit stats_sabeels_path
            end
            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Maimoon A")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#maimoon_a') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.maimoon_a.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should route to 'active' page on clicking 'active' button" do
                within('div#maimoon_a') do
                    click_on "Active: "
                    expect(current_path).to eql(active_sabeels_path("maimoon_a"))
                end
            end

            scenario "should route to 'inactive' page on clicking 'inactive' button" do
                within('div#maimoon_a') do
                    click_on "Inactive: "
                    expect(current_path).to eql(inactive_sabeels_path("maimoon_a"))
                end
            end

            scenario "should show total number of inactive sabeels" do
                within('div#maimoon_a') do
                    expect(page).to have_selector(:link_or_button, "Inactive: 2")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#maimoon_a') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.maimoon_a.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Maimoon B" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "maimoon_b")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit stats_sabeels_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Maimoon B")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#maimoon_b') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.maimoon_b.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should route to 'active' page on clicking 'active' button" do
                within('div#maimoon_b') do
                    click_on "Active: "
                    expect(current_path).to eql(active_sabeels_path("maimoon_b"))
                end
            end

            scenario "should route to 'inactive' page on clicking 'inactive' button" do
                within('div#maimoon_b') do
                    click_on "Inactive: "
                    expect(current_path).to eql(inactive_sabeels_path("maimoon_b"))
                end
            end

            scenario "should show total number of inactive sabeels" do
                within('div#maimoon_b') do
                    expect(page).to have_selector(:link_or_button, "Inactive: 2")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#maimoon_b') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.maimoon_b.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end
    end
end