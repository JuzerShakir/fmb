require 'rails_helper'

RSpec.describe "Sabeel features" do
    before do
        visit root_path
        click_on "New Sabeel"
        expect(current_path).to eql('/sabeels/new')

        expect(page).to have_css('h1', text: "New Sabeel")
    end

    context "creates sabeel" do
        scenario "with valid values" do
            attributes = FactoryBot.attributes_for(:sabeel)
            apt = attributes.extract!(:apartment)

            attributes.each do |k, v|
                fill_in k,	with: "#{v}"
            end
            select apt.fetch(:apartment).titleize, from: :apartment

            click_button "Create Sabeel"

            sabeel = Sabeel.last
            expect(current_path).to eql("/sabeels/#{sabeel.its}")
            expect(page).to have_content("Sabeel created successfully")
        end
    end
end