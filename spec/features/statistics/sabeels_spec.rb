# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Stats template" do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    create_list(:burhani_sabeel_taking_thaali, 2)
    create_list(:burhani_sabeel_took_thaali, 2)
    visit statistics_sabeels_path
  end

  # * ALL user types
  describe "visited by any user type" do
    it "shows heading & sub-heading" do
      expect(page).to have_title "Sabeel Statistics"
      expect(page).to have_css("h3", text: "Burhani")
    end

    describe "shows statistics of burhani building for current year" do
      let(:active_burhani_sabeels) { Sabeel.burhani.taking_thaali }

      it "Active & Inactive" do
        active_count = active_burhani_sabeels.count
        inactive_count = Sabeel.burhani.count - active_count

        within("section#burhani") do
          expect(page).to have_selector(:link_or_button, "Active: #{active_count}")
          expect(page).to have_selector(:link_or_button, "Inactive: #{inactive_count}")
        end
      end

      it "thaali count for size: small, medium & large" do
        small_count = active_burhani_sabeels.with_thaali_size("small").count
        med_count = active_burhani_sabeels.with_thaali_size("medium").count
        large_count = active_burhani_sabeels.with_thaali_size("large").count

        within("section#burhani") do
          expect(page).to have_content("Small: #{small_count}")
          expect(page).to have_content("Medium: #{med_count}")
          expect(page).to have_content("Large: #{large_count}")
        end
      end
    end
  end
end
