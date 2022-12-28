require 'rails_helper'

RSpec.describe "Sabeel features" do
    context "creating sabeel" do
        before do
            visit root_path
            click_on "New Sabeel"
            expect(current_path).to eql('/sabeels/new')

            expect(page).to have_css('h1', text: "New Sabeel")

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
            expect(current_path).to eql("/sabeels/#{sabeel.slug}")
            expect(page).to have_content("Sabeel created successfully")
        end

        scenario "should NOT be able to create with invalid values" do
            # we haven't selected any apartment, which is required, hence sabeel will not be saved

            click_button "Create Sabeel"

            expect(page).to have_content("Please review the problems below:")
            expect(page).to have_content("Apartment cannot be blank")
        end
    end

    context "show all sabeels" do
        before do
            @sabeels = FactoryBot.create_list(:sabeel, 3)
            visit all_sabeels_path
        end

        scenario "should have a link to ITS text that renders sabeel:show page after clicking it" do
            its = @sabeels.first.its
            click_link "#{its}"
            expect(current_path).to eql("/sabeels/#{its}")
        end
    end

    context "takhmeen details of a sabeel" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
        end

        scenario "should NOT be shown if they haven't done any takhmeen yet" do
            visit sabeel_path(@sabeel)
            expect(page).to have_no_link("New Transaction")
            expect(page).to have_content("Total Takhmeens 0")
        end

        context "if it exists" do
            before do
                2.times do |i|
                    FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id, year: $CURRENT_YEAR_TAKHMEEN - i)
                end
            end

            it "should BE shown" do
                visit sabeel_path(@sabeel)

                2.times do |i|
                    expect(page).to have_content($CURRENT_YEAR_TAKHMEEN - i)
                end
            end

            context "should have a 'New Transaction' button" do
                before do
                    @thaali_1 = @sabeel.thaali_takhmeens.first
                    @thaali_2 = @sabeel.thaali_takhmeens.last

                    # we will set thaali_1 as completed takhmeen and another as pending
                    FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali_1.id, amount: @thaali_1.total)
                    visit sabeel_path (@sabeel)
                end

                scenario "should BE shown whos takhmeen isn't complete" do
                    within "#thaali_#{@thaali_2.year}" do
                        expect(page).to have_link("New Transaction")
                    end
                end

                scenario "should NOT BE shown whos takhmeen isn't complete" do
                    within "#thaali_#{@thaali_1.year}" do
                        expect(page).to have_no_link("New Transaction")
                    end
                end
            end
        end
    end

    context "Editing Sabeel" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            visit sabeel_path(@sabeel)
        end

        it "should have an edit link" do
            expect(page).to have_link("Edit Sabeel")
        end

        scenario "should BE able to update with valid values" do
            click_link "Edit Sabeel"
            fill_in "sabeel_mobile", with: Faker::Number.number(digits: 10)

            click_on "Update Sabeel"
            expect(current_path).to eql("/sabeels/#{@sabeel.slug}")
            expect(page).to have_content("Sabeel updated successfully")
        end
    end
end