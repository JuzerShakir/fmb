# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Index template" do
  let(:user) { create(:user) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:sabeel, 2)
    visit sabeels_path
  end

  # * ALL user types
  describe "visited by any user type", :js do
    let(:sabeels) { Sabeel.first(2) }

    describe "shows all sabeel details" do
      it "ITS number" do
        sabeels.each { |sabeel| expect(page).to have_content(sabeel.its) }
      end

      it "name" do
        sabeels.each { |sabeel| expect(page).to have_content(sabeel.name) }
      end

      it "apartment" do
        sabeels.each { |sabeel| expect(page).to have_content(sabeel.apartment.titleize) }
      end
    end

    describe "can search" do
      context "with ITS number" do
        let(:its_numbers) { Sabeel.pluck(:its) }

        before { fill_in "q_name_or_its_cont", with: its_numbers.first }

        it { within("div#all-sabeels") { expect(page).to have_content(its_numbers.first) } }
        it { within("div#all-sabeels") { expect(page).not_to have_content(its_numbers.last) } }
      end

      context "with name" do
        let(:names) { Sabeel.pluck(:name) }

        before { fill_in "q_name_or_its_cont", with: names.first }

        it { within("div#all-sabeels") { expect(page).to have_content(names.first) } }
        it { within("div#all-sabeels") { expect(page).to have_content(names.last) } }
      end
    end
  end
end
