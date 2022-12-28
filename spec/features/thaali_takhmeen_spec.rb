require "rails_helper"

RSpec.describe "ThaaliTakhmeen features" do
    before do
        @sabeel = FactoryBot.create(:sabeel)
    end

    context "'Create Takhmeen' link to be" do
        scenario "visible if sabeel is NOT taking thaali for current year" do
            thaali = FactoryBot.create(:thaali_takhmeen_of_previous_year, sabeel_id: @sabeel.id)

            visit sabeel_path(@sabeel)

            expect(page).to have_link('New Takhmeen')
        end

        scenario "NOT visible if sabeel is ALREADY taking thaali for current year" do
            thaali = FactoryBot.create(:thaali_takhmeen_of_current_year, sabeel_id: @sabeel.id)

            visit sabeel_path(@sabeel)

            expect(page).to have_no_link('New Takhmeen')
        end
    end

    context "creating ThaaliTakhmeen" do
        before do
            visit sabeel_path(@sabeel)

            click_on "New Takhmeen"
            expect(current_path).to eql new_sabeel_takhmeen_path(@sabeel)
            expect(page).to have_css('h1', text: "New Takhmeen")

            attributes = FactoryBot.attributes_for(:thaali_takhmeen).extract!(:number, :total, :size)
            @size = attributes.extract!(:size)

            attributes.each do |k, v|
                fill_in "thaali_takhmeen_#{k}",	with: "#{v}"
            end
        end

        scenario "should BE able to create with valid values" do
            select @size.fetch(:size).to_s.titleize, from: :thaali_takhmeen_size

            click_button "Create Thaali takhmeen"

            thaali_takhmeen = ThaaliTakhmeen.last
            expect(current_path).to eql takhmeen_path(thaali_takhmeen)
            expect(page).to have_content("Thaali Takhmeen created successfully")
        end


        scenario "should NOT BE able to create with invalid values" do
            click_button "Create Thaali takhmeen"

            # we haven't selected any apartment, which is required, hence sabeel will not be saved
            expect(page).to have_content("Please review the problems below:")
            expect(page).to have_content("Size cannot be blank")
        end
    end

    context "Editing ThaaliTakhmneens" do
        before do
            @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
            visit takhmeen_path(@thaali)
        end
        scenario "should BE able to update with valid values" do
            click_on "Edit Takhmeen"
            expect(current_path).to eql edit_takhmeen_path(@thaali)

            fill_in "thaali_takhmeen_number", with: "#{Random.rand(1..400)}"
            click_on "Update Thaali takhmeen"

            expect(page).to have_content("Thaali Takhmeen updated successfully")
        end
    end

    scenario "Showing ThaaliTakhmeen" do
        @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)

        visit takhmeen_path(@thaali)

        FactoryBot.attributes_for(:thaali_takhmeen).keys.each do | attrb |
            expect(page).to have_content("#{@thaali.send(attrb)}")
        end
    end

    scenario "Deleting ThaaliTakhmeen" do
        @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        visit takhmeen_path(@thaali)
        expect(page).to have_button("Delete Takhmeen")

        click_on "Delete Takhmeen"
        expect(current_path).to eql sabeel_path(@sabeel)
        expect(page).to have_content("Thaali Takhmeen destroyed successfully")
    end
end