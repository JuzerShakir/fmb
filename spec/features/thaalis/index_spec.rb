# frozen_string_literal: true

require "rails_helper"
require_relative "thaali_helpers"

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
    it_behaves_like "view thaali records"

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
