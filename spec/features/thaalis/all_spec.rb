# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali all template" do
  let(:user) { create(:user) }
  let(:thaalis) { Thaali.first(2) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:previous_thaali, 2)

    visit thaalis_all_path(PREV_YR)
  end

  # * ALL user types
  describe "visited by any user type can" do
    describe "view all its details", :js do
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
    end
  end
end
