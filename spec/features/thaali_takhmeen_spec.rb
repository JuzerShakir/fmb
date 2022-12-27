require "rails_helper"

RSpec.describe "ThaaliTakhmeen features" do
    context "creates ThaaliTakhmeen" do
        before do
            sabeel = FactoryBot.create(:sabeel)
            visit sabeel_path(sabeel.slug)
            click_on "New Takhmeen"
            expect(current_path).to eql("/sabeels/#{sabeel.slug}/takhmeens/new")
            @attributes = FactoryBot.attributes_for(:thaali_takhmeen).extract!(:year,:number, :total, :size)
        end

        scenario "with valid values" do
            expect(page).to have_css('h1', text: "New Takhmeen")
            s = @attributes.extract!(:size)

            @attributes.each do |k, v|
                fill_in "thaali_takhmeen_#{k}",	with: "#{v}"
            end

            select s.fetch(:size).to_s.titleize, from: :thaali_takhmeen_size

            click_button "Create Thaali takhmeen"

            thaali_takhmeen = ThaaliTakhmeen.last
            expect(current_path).to eql("/takhmeens/#{thaali_takhmeen.slug}")
            expect(page).to have_content("Thaali Takhmeen created successfully")
        end

        # scenario "with invalid values" do

        # end
    end
end