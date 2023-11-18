# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali index template" do
  let(:user) { create(:user) }
  let(:thaalis) { Thaali.first(2) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:taking_thaali, 2)

    visit root_path
  end

  # * ALL user types
  describe "visited by any user type can", :js do
    describe "view all transaction details" do
      it "thaali_number" do
        thaalis.each do |thaali|
          number = thaali.number
          expect(page).to have_content(number)
        end
      end

      it "name" do
        thaalis.each do |thaali|
          sabeel = thaali.sabeel
          expect(page).to have_content(sabeel.name)
        end
      end

      it "balance" do
        thaalis.each do |thaali|
          expect(page).to have_content(number_with_delimiter(thaali.balance))
        end
      end
    end

    describe "search" do
      context "with thaali number" do
        let(:thaali_number) { Thaali.first.number }

        before { fill_in "q_number_eq", with: thaali_number }

        it { within("div#thaalis") { expect(page).to have_content(thaali_number) } }
        it { within("div#thaalis") { expect(page).not_to have_content(Thaali.last.number) } }
      end
    end
  end
end
