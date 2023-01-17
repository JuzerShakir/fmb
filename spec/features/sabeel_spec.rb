require 'rails_helper'

RSpec.describe "Sabeel features" do
    before do
        @sabeel = FactoryBot.create(:sabeel)
    end

    context "creating sabeel" do
        before do
            visit root_path
            click_on "New Sabeel"
            expect(current_path).to eql new_sabeel_path

            expect(page).to have_css('h2', text: "New Sabeel")

            attributes = FactoryBot.attributes_for(:sabeel)
            @apt = attributes.extract!(:apartment)

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

    context "show all sabeels", js: true do
        before do
            @sabeels = FactoryBot.create_list(:sabeel, 3)
            visit all_sabeels_path
        end

        scenario "should have a link to ITS text that renders sabeel:show page after clicking it" do
            @sabeels.each do |sabeel|
                its = sabeel.its
                expect(page).to have_content("#{its}")

                click_button "#{its}"
                expect(current_path).to eql sabeel_path(its)
                page.driver.go_back
            end
        end

        scenario "should show HOF name, Address & Mobile number of the sabeel" do
            @sabeels.each do |sabeel|
                expect(page).to have_content("#{sabeel.hof_name}")
                expect(page).to have_content("#{sabeel.address}")
                expect(page).to have_content("#{sabeel.mobile}")
            end
        end
    end

    context "takhmeen details of a sabeel" do
        context "if it exists" do
            before do
                2.times do |i|
                    FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id, year: $active_takhmeen - i)
                end
                visit sabeel_path(@sabeel)
                @thaalis = @sabeel.thaali_takhmeens
            end

            scenario "should show total number of takhmeens" do
                expect(page).to have_content("Total number of Takhmeens: #{@thaalis.count}")
            end

            scenario "should show 'year', 'total', 'balance' values" do
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

            scenario "should be able to visit thaali show page after clicking on the year" do
                @thaalis.each do | thaali |
                    year = thaali.year
                    click_button "#{year}"
                    expect(current_path).to eql takhmeen_path(thaali)
                    visit sabeel_path(@sabeel)
                end
            end
        end
    end

    context "Editing Sabeel" do
        before do
            visit sabeel_path(@sabeel)
        end

        scenario "should have an edit link" do
            expect(page).to have_link("Edit Sabeel")
        end

        scenario "should BE able to update with valid values" do
            click_link "Edit Sabeel"
            fill_in "sabeel_mobile", with: Faker::Number.number(digits: 10)

            click_on "Update Sabeel"
            expect(current_path).to eql sabeel_path(@sabeel)
            expect(page).to have_content("Sabeel updated successfully")
        end
    end

    scenario "Showing a Sabeel details" do
        visit sabeel_path(@sabeel)

        attrbs = FactoryBot.attributes_for(:sabeel).except!(:apartment, :flat_no)

        attrbs.keys.each do | attrb |
            expect(page).to have_content("#{@sabeel.send(attrb)}")
        end
    end

    scenario "Deleting a Sabeel" do
        visit sabeel_path(@sabeel)

        expect(page).to have_button('Delete Sabeel')

        click_on "Delete Sabeel"
        click_on "Yes, delete it!"

        expect(current_path).to eql root_path("format=html")
        expect(page).to have_content("Sabeel deleted successfully")
    end

    #* Active
    context "Active template", js: true do
        before do
            @apt = Sabeel.apartments.keys.sample
            @sabeels = FactoryBot.create_list(:sabeel, 3, apartment: @apt)
            @sabeels.each do |sabeel|
                FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id)
            end
            visit sabeels_active_path(@apt)
        end

        scenario "should have a header" do
            expect(page).to have_css("h2", text: "Active Sabeels of #{@apt.titleize}")
        end

        scenario "should list all the active sabeels of an apartment" do
            @sabeels.each do |sabeel|
                expect(page).to have_content("#{sabeel.flat_no}")
                expect(page).to have_content("#{sabeel.hof_name}")
                thaali = sabeel.thaali_takhmeens.first
                expect(page).to have_content("#{thaali.number}")
                expect(page).to have_content("#{thaali.size.humanize.chr}")
            end
        end

        # ! No route matches [GET] "/@fortawesome/fontawesome-free/webfonts/fa-solid-900.woff2"
        # scenario "should be able to visit sabeel show page after clicking on the flat_no" do
        #     @sabeels.each do | sabeel |
        #         flat_no = sabeel.flat_no
        #         click_button "#{flat_no}"
        #         expect(current_path).to eql sabeel_path(sabeel)
        #         visit sabeels_active_path(@apt)
        #     end
        # end

        # ! No route matches [GET] "/@fortawesome/fontawesome-free/webfonts/fa-solid-900.woff2"
        # scenario "should be able to visit thaali show page after clicking on the thaali_number" do
        #     @sabeels.each do | sabeel |
        #         thaali = sabeel.thaali_takhmeens.first
        #         click_button "#{thaali.number}"
        #         expect(current_path).to eql takhmeen_path(thaali)
        #         visit sabeels_active_path(@apt)
        #     end
        # end
    end

    #* Total
    context "Total" do
        before do
            @apt = Sabeel.apartments.keys.sample
            @sabeels = FactoryBot.create_list(:sabeel, 3, apartment: @apt)
            visit sabeels_total_path(@apt)
        end

        scenario "should have a header" do
            expect(page).to have_css("h2", text: "All Sabeels for #{@apt.titleize}")
        end

        # scenario "should list all the active sabeels of an apartment" do
        #     expect(page).to have_content("#{@sabeels.first.address}")
        # end
    end

    # * Statistics
    context "Statistics" do
        before do
            @sizes = ThaaliTakhmeen.sizes.keys
        end

        scenario "should have a header" do
            visit sabeels_stats_path
            expect(page).to have_css("h2", text: "Sabeel Statistics for #{$active_takhmeen}")
        end

        context "for Maimoon A" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "maimoon_a")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end
            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Maimoon A")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#maimoon_a') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.maimoon_a.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#maimoon_a') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("maimoon_a"))
                end
            end

            scenario "should redirect to inactive sabeels page by clicking 'inactive' button" do
                within('div#maimoon_a') do
                    click_on "Inactive: "
                    expect(current_path).to eql(sabeels_inactive_path("maimoon_a"))
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
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Maimoon B")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#maimoon_b') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.maimoon_b.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#maimoon_b') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("maimoon_b"))
                end
            end

            scenario "should redirect to inactive sabeels page by clicking 'inactive' button" do
                within('div#maimoon_b') do
                    click_on "Inactive: "
                    expect(current_path).to eql(sabeels_inactive_path("maimoon_b"))
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