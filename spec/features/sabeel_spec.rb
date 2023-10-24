# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel" do
  before { page.set_rack_session(user_id: user.id) }

  # * ALL user types
  describe "Any logged-in users can visit" do
    let(:user) { create(:user) }

    # * SHOW
    describe "'show' template" do
      let(:sabeel) { create(:sabeel) }

      before { visit sabeel_path(sabeel) }

      context "with its details" do
        it { expect(page).to have_content(sabeel.its) }
        it { expect(page).to have_content(sabeel.name) }
        it { expect(page).to have_content(sabeel.address) }
        it { expect(page).to have_content(sabeel.mobile) }
        it { expect(page).to have_content(sabeel.email) }
      end

      context "with action buttons" do
        it { expect(page).to have_link("Edit") }
        it { expect(page).to have_button("Delete") }
      end

      describe "thaali" do
        context "when it's NOT actively taking it" do
          it { expect(page).to have_button("New Takhmeen") }
        end

        context "when it's ACTIVELY taking it" do
          let(:active_sabeel) { create(:active_sabeel) }
          let(:count) { active_sabeel.thaali_takhmeens.count }
          let(:thaali) { active_sabeel.thaali_takhmeens.first }

          before { visit sabeel_path(active_sabeel) }

          it { expect(page).not_to have_button("New Takhmeen") }

          describe "show all its details" do
            it { expect(page).to have_content("Total number of Takhmeens: #{count}") }
            it { expect(page).to have_content(thaali.year) }
            it { expect(page).to have_content(number_with_delimiter(thaali.total)) }
            it { expect(page).to have_content(number_with_delimiter(thaali.balance)) }
          end
        end
      end
    end

    # * INDEX
    describe "'index' template", :js do
      let(:sabeels) { Sabeel.first(2) }

      before do
        create_list(:sabeel, 2)
        visit sabeels_path
      end

      describe "show all its details" do
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

      describe "search" do
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

    # * ACTIVE
    describe "'active' template", :js do
      let!(:sabeel) { create(:active_sabeel_burhani) }
      let(:thaali) { sabeel.thaali_takhmeens.first }

      before { visit sabeels_active_path("burhani") }

      describe "Generate PDF button" do
        it { expect(page).to have_button("Generate PDF") }
        it { expect(page).to have_css(".fa-file-pdf") }

        describe "Generates PDF of burhani building with active sabeel details" do
          let(:pdf_window) { switch_to_window(windows.last) }

          before { click_button("Generate PDF") }

          # FIXME: for the test to pass in github actions wait 5 sec until the header appears
          it { within_window pdf_window { expect(page).to have_content("Burhani - #{CURR_YR}") } }
          it { within_window pdf_window { expect(page).to have_content(sabeel.flat_no) } }
          it { within_window pdf_window { expect(page).to have_content(sabeel.name) } }
          it { within_window pdf_window { expect(page).to have_content(sabeel.mobile) } }
          it { within_window pdf_window { expect(page).to have_content(thaali.number) } }
          it { within_window pdf_window { expect(page).to have_content(thaali.size.humanize.chr) } }
        end
      end

      describe "showing its details" do
        it { expect(page).to have_content(sabeel.flat_no) }
        it { expect(page).to have_content(sabeel.name) }
        it { expect(page).to have_content(thaali.number) }
        it { expect(page).to have_content(thaali.size.humanize.chr) }
      end
    end

    # * INACTIVE
    describe "'inactive' template", :js do
      let!(:sabeel) { create(:burhani_sabeel_with_previous_takhmeen) }

      before { visit sabeels_inactive_path("burhani") }

      describe "showing its details" do
        it { expect(page).to have_content(sabeel.name) }
        it { expect(page).to have_content(sabeel.its) }
      end
    end

    # * Statistics
    describe "'statistics' template" do
      describe "to see burhani building statistic for current year" do
        let(:active_burhani_sabeels) { Sabeel.burhani.active_takhmeen(CURR_YR) }

        before do
          create_list(:active_sabeel_burhani, 2)
          create_list(:burhani_sabeel_with_previous_takhmeen, 2)
          visit stats_sabeels_path
        end

        it { expect(page).to have_css("h3", text: "Burhani") }

        it "Active" do
          within("div#burhani") do
            count = active_burhani_sabeels.count
            expect(page).to have_selector(:link_or_button, "Active: #{count}")
          end
        end

        it "Inactive" do
          within("div#burhani") do
            count = Sabeel.inactive_apt_takhmeen("burhani").count
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

  # * ONLY Admin types
  describe "'Admin'" do
    let(:user) { create(:admin_user) }

    #  * CREATE
    describe "creating it" do
      before do
        visit new_sabeel_path

        attributes_for(:sabeel).except(:apartment).each do |k, v|
          fill_in "sabeel_#{k}", with: v
        end
      end

      context "with valid values" do
        let(:apartment) { Sabeel.apartments.keys.sample.titleize }

        before do
          select apartment, from: :sabeel_apartment
          click_button "Create Sabeel"
        end

        it "redirects to newly created thaali" do
          sabeel = Sabeel.last
          expect(page).to have_current_path sabeel_path(sabeel)
        end

        it { expect(page).to have_content("Sabeel created successfully") }
      end

      context "with invalid values" do
        before { click_button "Create Sabeel" }

        it { expect(page).to have_content("selection is required") }
      end
    end

    # * DELETE
    describe "deleting sabeel" do
      let(:sabeel) { create(:sabeel) }

      before do
        visit sabeel_path(sabeel)
        click_button "Delete"
      end

      it "shows confirmation message" do
        within(".modal-body") do
          expect(page).to have_content("Are you sure you want to delete this Sabeel? This action cannot be undone.")
        end
      end

      context "with action buttons" do
        it { within(".modal-footer") { expect(page).to have_css(".btn-secondary", text: "Cancel") } }
        it { within(".modal-footer") { expect(page).to have_css(".btn-primary", text: "Yes, delete it!") } }
      end

      describe "destroy" do
        before do
          click_button "Yes, delete it!"
        end

        it { expect(page).to have_current_path root_path, ignore_query: true }
        it { expect(page).to have_content("Sabeel deleted successfully") }
      end
    end
  end
end
