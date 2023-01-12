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

    # context "show all sabeels" do
    #     before do
    #         @sabeels = FactoryBot.create_list(:sabeel, 3)
    #         visit all_sabeels_path
    #     end

    #     scenario "should have a link to ITS text that renders sabeel:show page after clicking it" do
    #         its = @sabeels.last.its
    #         expect(page).to have_content("#{its}")

            # click_button "#{its}"
            # expect(current_path).to eql sabeel_path(its)
    #     end
    # end

    context "takhmeen details of a sabeel" do
        context "if it exists" do
            before do
                2.times do |i|
                    FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id, year: $active_takhmeen - i)
                end
                visit sabeel_path(@sabeel)
            end

            scenario "should BE shown" do
                2.times do |i|
                    expect(page).to have_content($active_takhmeen - i)
                end
            end

            scenario "should show total number of takhmeens" do
                expect(page).to have_content("Total number of Takhmeens: #{@sabeel.thaali_takhmeens.count}")
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

        expect(current_path).to eql root_path
        expect(page).to have_content("Sabeel deleted successfully")
    end

    #* Active
    context "Active" do
        before do
            @apt = Sabeel.apartments.keys.sample
            @sabeels = FactoryBot.create_list(:sabeel, 3, apartment: @apt)
            @sabeels.each do |sabeel|
                FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id)
            end
            visit sabeels_active_path(@apt)
        end

        scenario "should have a header" do
            expect(page).to have_css("h2", text: "Active Sabeels for #{@apt.titleize}")
        end

        # scenario "should list all the active sabeels of an apartment" do
        #     expect(page).to have_content("#{@sabeels.first.address}")
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

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#maimoon_a') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("maimoon_a"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#maimoon_a') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.maimoon_a.count}")
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

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#maimoon_b') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("maimoon_b"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#maimoon_b') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.maimoon_b.count}")
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

        context "for Qutbi A" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "qutbi_a")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Qutbi A")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#qutbi_a') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.qutbi_a.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#qutbi_a') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("qutbi_a"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#qutbi_a') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("qutbi_a"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#qutbi_a') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.qutbi_a.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#qutbi_a') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.qutbi_a.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Qutbi B" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "qutbi_b")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Qutbi B")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#qutbi_b') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.qutbi_b.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#qutbi_b') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("qutbi_b"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#qutbi_b') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("qutbi_b"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#qutbi_b') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.qutbi_b.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#qutbi_b') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.qutbi_b.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Najmi" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "najmi")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Najmi")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#najmi') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.najmi.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#najmi') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("najmi"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#najmi') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("najmi"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#najmi') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.najmi.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#najmi') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.najmi.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Noorani A" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "noorani_a")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Noorani A")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#noorani_a') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.noorani_a.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#noorani_a') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("noorani_a"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#noorani_a') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("noorani_a"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#noorani_a') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.noorani_a.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#noorani_a') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.noorani_a.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Noorani B" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "noorani_b")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end


            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Noorani B")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#noorani_b') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.noorani_b.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#noorani_b') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("noorani_b"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#noorani_b') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("noorani_b"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#noorani_b') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.noorani_b.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#noorani_b') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.noorani_b.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Husami A" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "husami_a")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Husami A")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#husami_a') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.husami_a.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#husami_a') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("husami_a"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#husami_a') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("husami_a"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#husami_a') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.husami_a.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#husami_a') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.husami_a.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Husami B" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "husami_b")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Husami B")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#husami_b') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.husami_b.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#husami_b') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("husami_b"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#husami_b') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("husami_b"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#husami_b') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.husami_b.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#husami_b') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.husami_b.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Mohammedi" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "mohammedi")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Mohammedi")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#mohammedi') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.mohammedi.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#mohammedi') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("mohammedi"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#mohammedi') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("mohammedi"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#mohammedi') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.mohammedi.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#mohammedi') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.mohammedi.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Saifee" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "saifee")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Saifee")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#saifee') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.saifee.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#saifee') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("saifee"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#saifee') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("saifee"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#saifee') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.saifee.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#saifee') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.saifee.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Jamali" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "jamali")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Jamali")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#jamali') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.jamali.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#jamali') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("jamali"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#jamali') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("jamali"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#jamali') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.jamali.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#jamali') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.jamali.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Taiyebi" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "taiyebi")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Taiyebi")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#taiyebi') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.taiyebi.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#taiyebi') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("taiyebi"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#taiyebi') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("taiyebi"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#taiyebi') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.taiyebi.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#taiyebi') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.taiyebi.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Imadi" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "imadi")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Imadi")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#imadi') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.imadi.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#imadi') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("imadi"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#imadi') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("imadi"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#imadi') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.imadi.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#imadi') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.imadi.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Burhani" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "burhani")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Burhani")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#burhani') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.burhani.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#burhani') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("burhani"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#burhani') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("burhani"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#burhani') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.burhani.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#burhani') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.burhani.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Zaini" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "zaini")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Zaini")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#zaini') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.zaini.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#zaini') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("zaini"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#zaini') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("zaini"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#zaini') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.zaini.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#zaini') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.zaini.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Fakhri" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "fakhri")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Fakhri")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#fakhri') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.fakhri.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#fakhri') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("fakhri"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#fakhri') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("fakhri"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#fakhri') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.fakhri.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#fakhri') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.fakhri.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Badri" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "badri")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Badri")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#badri') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.badri.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#badri') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("badri"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#badri') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("badri"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#badri') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.badri.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#badri') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.badri.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end

        context "for Ezzi" do
            before do
                @sabeels = FactoryBot.create_list(:sabeel, 5, apartment: "ezzi")
                @sabeels.first(3).each.with_index do |sabeel, i|
                    FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id, size: @sizes[i])
                end
                visit sabeels_stats_path
            end

            scenario "should have a title" do
                expect(page).to have_css("h3", text: "Ezzi")
            end

            scenario "should show number of active takmeen sabeels count" do
                within('div#ezzi') do
                    expect(page).to have_selector(:link_or_button, "Active: #{Sabeel.ezzi.active_takhmeen($active_takhmeen).count}")
                end
            end

            scenario "should redirect to active sabeels page by clicking 'active' button" do
                within('div#ezzi') do
                    click_on "Active: "
                    expect(current_path).to eql(sabeels_active_path("ezzi"))
                end
            end

            scenario "should redirect to total sabeels page by clicking 'total' button" do
                within('div#ezzi') do
                    click_on "Total: "
                    expect(current_path).to eql(sabeels_total_path("ezzi"))
                end
            end

            scenario "should show total number of sabeels" do
                within('div#ezzi') do
                    expect(page).to have_selector(:link_or_button, "Total: #{Sabeel.ezzi.count}")
                end
            end

            scenario "should show total number of thaali sizes" do
                within('div#ezzi') do
                    @sizes.each do |size|
                        expect(page).to have_content("#{size.humanize}: #{Sabeel.ezzi.active_takhmeen($active_takhmeen).with_the_size(size).count}")
                    end
                end
            end
        end
    end
end