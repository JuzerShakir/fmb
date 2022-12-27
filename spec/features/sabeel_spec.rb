require 'rails_helper'

RSpec.describe "Sabeel features" do
    context "creates sabeel" do
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
        scenario "with valid values" do
            select @apt.fetch(:apartment).titleize, from: :sabeel_apartment

            click_button "Create Sabeel"

            sabeel = Sabeel.last
            expect(current_path).to eql("/sabeels/#{sabeel.slug}")
            expect(page).to have_content("Sabeel created successfully")
        end

        scenario "with invalid values" do
            # we haven't selected any apartment, which is required, hence sabeel will not be saved

            click_button "Create Sabeel"

            expect(page).to have_content("Please review the problems below:")
            expect(page).to have_content("Apartment cannot be blank")
        end
    end
end