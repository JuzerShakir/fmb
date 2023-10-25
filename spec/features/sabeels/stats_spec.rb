# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Stats template" do
  let(:user) { create(:user) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:active_sabeel_burhani, 2)
    create_list(:burhani_sabeel_with_previous_thaali, 2)
    visit stats_sabeels_path
  end

  # * ALL user types
  describe "visited by any user type" do
    describe "shows statistics of burhani building for current year" do
      let(:active_burhani_sabeels) { Sabeel.burhani.active_thaalis(CURR_YR) }

      it { expect(page).to have_css("h3", text: "Burhani") }

      it "Active" do
        within("div#burhani") do
          count = active_burhani_sabeels.count
          expect(page).to have_selector(:link_or_button, "Active: #{count}")
        end
      end

      it "Inactive" do
        within("div#burhani") do
          count = Sabeel.inactive_apt_thaalis("burhani").count
          expect(page).to have_selector(:link_or_button, "Inactive: #{count}")
        end
      end

      describe "size count for" do
        it "small" do
          within("div#burhani") do
            count = active_burhani_sabeels.with_the_size("small").count
            expect(page).to have_content("Small: #{count}")
          end
        end

        it "medium" do
          within("div#burhani") do
            count = active_burhani_sabeels.with_the_size("medium").count
            expect(page).to have_content("Medium: #{count}")
          end
        end

        it "large" do
          within("div#burhani") do
            count = active_burhani_sabeels.with_the_size("large").count
            expect(page).to have_content("Large: #{count}")
          end
        end
      end
    end
  end
end
