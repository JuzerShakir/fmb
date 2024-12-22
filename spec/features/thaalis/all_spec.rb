# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali all template" do
  let(:user) { create(:user) }
  let(:year) { [CURR_YR, PREV_YR].sample }
  let(:thaalis) { Thaali.first(2) }

  before do
    sign_in(user)
    create_list(:thaali, 2, year:)
    visit thaalis_all_path(year)
  end

  # * ALL user types
  describe "visited by any user type can" do
    it { expect(page).to have_title "Thaalis in #{year}" }

    it_behaves_like "view thaali records"

    describe "search with thaali number", :js do
      let(:thaali_number) { Thaali.first.number }

      before { fill_in "q_number_eq", with: thaali_number }

      it "returns correct thaali" do
        within("section#thaalis") do
          expect(page).to have_content(thaali_number)
          expect(page).to have_no_content(Thaali.last.number)
        end
      end
    end
  end
end
