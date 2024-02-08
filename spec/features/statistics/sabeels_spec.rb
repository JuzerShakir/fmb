# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Stats template" do
  let(:user) { create(:user) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:burhani_sabeel_taking_thaali, 2)
    create_list(:burhani_sabeel_took_thaali, 2)
    visit statistics_sabeels_path
  end

  # * ALL user types
  describe "visited by any user type" do
    it { expect(page).to have_title "Sabeel Statistics" }

    describe "shows statistics of burhani building for current year" do
      let(:active_burhani_sabeels) { Sabeel.burhani.taking_thaali }

      it { expect(page).to have_css("h3", text: "Burhani") }

      it "Active" do
        within("section#burhani") do
          count = active_burhani_sabeels.count
          expect(page).to have_selector(:link_or_button, "Active: #{count}")
        end
      end

      it "Inactive" do
        within("section#burhani") do
          count = Sabeel.burhani.count - active_burhani_sabeels.count
          expect(page).to have_selector(:link_or_button, "Inactive: #{count}")
        end
      end

      describe "size count for" do
        it "small" do
          within("section#burhani") do
            count = active_burhani_sabeels.with_thaali_size("small").count
            expect(page).to have_content("Small: #{count}")
          end
        end

        it "medium" do
          within("section#burhani") do
            count = active_burhani_sabeels.with_thaali_size("medium").count
            expect(page).to have_content("Medium: #{count}")
          end
        end

        it "large" do
          within("section#burhani") do
            count = active_burhani_sabeels.with_thaali_size("large").count
            expect(page).to have_content("Large: #{count}")
          end
        end
      end
    end
  end
end
