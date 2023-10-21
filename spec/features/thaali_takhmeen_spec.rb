# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ThaaliTakhmeen" do
  before { page.set_rack_session(user_id: user.id) }

  # * ALL user types
  describe "Any logged-in users can visit" do
    let(:user) { create(:user) }

    before { visit root_path }

    #  * SHOW
    describe "'show' template" do
      let(:thaali) { create(:thaali_with_transaction) }
      let(:transaction) { thaali.transactions.first }

      before { visit takhmeen_path(thaali) }

      context "with its details" do
        it { expect(page).to have_content(thaali.size.humanize) }
        it { expect(page).to have_content(number_with_delimiter(thaali.total)) }
        it { expect(page).to have_content(number_with_delimiter(thaali.balance)) }
      end

      context "with action buttons" do
        it { expect(page).to have_link("Edit") }
        it { expect(page).to have_button("Delete") }
      end

      context "with transaction details" do
        it do
          expect(page).to have_content("Total number of Transactions: #{thaali.transactions.count}")
        end

        it { expect(page).to have_content(transaction.recipe_no.to_s) }
        it { expect(page).to have_content(number_with_delimiter(transaction.amount)) }
        it { expect(page).to have_content(time_ago_in_words(transaction.date)) }
      end
    end

    # * INDEX
    describe "'index' template", :js do
      let(:thaalis) { ThaaliTakhmeen.first(2) }

      before do
        create_list(:active_takhmeen, 2)
        visit root_path
      end

      describe "show all its details" do
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

      describe "search" do
        context "with thaali number" do
          let(:thaali_numbers) { ThaaliTakhmeen.pluck(:number) }

          before { fill_in "q_number_cont", with: thaali_numbers.first }

          it { within("div#all-thaalis") { expect(page).to have_content(thaali_numbers.first) } }
          it { within("div#all-thaalis") { expect(page).not_to have_content(thaali_numbers.last) } }
        end
      end
    end

    # * COMPLETE
    describe "'complete' template", :js do
      let(:thaalis) { ThaaliTakhmeen.first(2) }

      before do
        create_list(:active_completed_takhmeens, 2)
        visit thaali_takhmeens_complete_path(CURR_YR)
      end

      describe "show all its details" do
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

    # * PENDING
    describe "'pending' template", :js do
      let(:thaalis) { ThaaliTakhmeen.first(2) }

      before do
        create_list(:active_takhmeen, 2)
        visit thaali_takhmeens_pending_path(CURR_YR)
      end

      describe "show all its details" do
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

    # * ALL
    describe "'all' template", :js do
      let(:thaalis) { ThaaliTakhmeen.first(2) }

      before do
        create_list(:previous_takhmeen, 2)
        visit thaali_takhmeens_all_path(PREV_YR)
      end

      describe "show all its details" do
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

    # * Statistics
    describe "'statistics' template" do
      describe "show statistic details of all thaalis for current year" do
        let(:thaalis) { ThaaliTakhmeen.in_the_year(CURR_YR) }

        before do
          create_list(:active_takhmeen, 2)
          create_list(:active_completed_takhmeens, 2)
          visit takhmeens_stats_path
        end

        it "Total" do
          within("div##{CURR_YR}") do
            total = thaalis.pluck(:total).sum
            expect(page).to have_content(number_with_delimiter(total))
          end
        end

        it "Balance" do
          within("div##{CURR_YR}") do
            balance = thaalis.pluck(:balance).sum
            expect(page).to have_content(number_with_delimiter(balance))
          end
        end

        it "Complete" do
          within("div##{CURR_YR}") do
            expect(page).to have_selector(:link_or_button,
              "Complete: #{ThaaliTakhmeen.completed_year(CURR_YR).count}")
          end
        end

        it "Pending" do
          within("div##{CURR_YR}") do
            expect(page).to have_selector(:link_or_button,
              "Pending: #{ThaaliTakhmeen.pending_year(CURR_YR).count}")
          end
        end

        it "each size" do
          within("div##{CURR_YR}") do
            ThaaliTakhmeen.sizes.keys.each do |size|
              expect(page).to have_content("#{size.humanize}: #{thaalis.send(size).count}")
            end
          end
        end

        it "total active takhmeens count" do
          within("div##{CURR_YR}") do
            expect(page).to have_selector(:link_or_button,
              "Total Takhmeens: #{thaalis.count}")
          end
        end
      end
    end
  end

  # * ONLY Admins & Members
  describe "'Admin' & 'Member'" do
    let(:user) { create(:user_other_than_viewer) }

    before { visit root_path }

    # * NEW
    describe "'new' template" do
      before { visit new_sabeel_takhmeen_path(sabeel) }

      context "when sabeel DIDN'T take it in previous year" do
        let(:sabeel) { create(:sabeel) }

        describe "displays with empty form fields" do
          it { expect(find_field("Number").value).to be_nil }
          it { expect(find_field("Size").value).to eq "" }
          it { expect(find_field("Total").value).to be_nil }
        end
      end

      context "when sabeel did take it in previous year" do
        let(:sabeel) { create(:sabeel_with_previous_takhmeen) }
        let(:thaali) { sabeel.thaali_takhmeens.first }

        describe "displays form fields with previous values" do
          it { expect(find_field("Number").value).to eq thaali.number.to_s }
          it { expect(find_field("Size").value).to eq thaali.size.to_s }
        end
      end
    end

    #  * CREATE
    describe "creating thaali" do
      let(:sabeel) { create(:sabeel) }
      let(:thaali) { attributes_for(:thaali_takhmeen, sabeel:) }

      before do
        visit new_sabeel_takhmeen_path(sabeel)
        fill_in "thaali_takhmeen_number", with: thaali[:number]
        fill_in "thaali_takhmeen_total", with: thaali[:total]
      end

      context "with valid values" do
        before do
          select thaali[:size].to_s.titleize, from: :thaali_takhmeen_size
          click_button "Create Thaali takhmeen"
        end

        it "redirects to newly created thaali" do
          thaali_takhmeen = ThaaliTakhmeen.last
          expect(page).to have_current_path takhmeen_path(thaali_takhmeen)
        end

        it { expect(page).to have_content("Thaali Takhmeen created successfully") }
      end

      context "with invalid values" do
        before { click_button "Create Thaali takhmeen" }

        it { expect(page).to have_content("Size cannot be blank") }
      end
    end

    #  * EDIT
    describe "updating it" do
      let(:thaali) { create(:thaali_takhmeen) }

      before { visit edit_takhmeen_path(thaali) }

      context "with valid values" do
        before do
          fill_in "thaali_takhmeen_number", with: Random.rand(1..400)
          click_button "Update Thaali takhmeen"
        end

        it { expect(page).to have_content("Thaali Takhmeen updated successfully") }
      end

      context "with invalid values" do
        before do
          fill_in "thaali_takhmeen_number", with: 0
          click_button "Update Thaali takhmeen"
        end

        it { expect(page).to have_content("Number must be greater than 0") }
      end
    end

    # * DELETE
    describe "deleting it" do
      let(:thaali) { create(:thaali_takhmeen) }

      before do
        visit takhmeen_path(thaali)
        click_button "Delete"
      end

      it "shows confirmation message" do
        within(".modal-body") do
          expect(page).to have_content("Are you sure you want to delete Thaali no: #{thaali.number}? This action cannot be undone.")
        end
      end

      context "with action buttons" do
        it { within(".modal-footer") { expect(page).to have_css(".btn-secondary", text: "Cancel") } }
        it { within(".modal-footer") { expect(page).to have_css(".btn-primary", text: "Yes, delete it!") } }
      end

      describe "destroy" do
        before { click_button "Yes, delete it!" }

        it { expect(page).to have_current_path sabeel_path(thaali.sabeel) }
        it { expect(page).to have_content("Thaali Takhmeen destroyed successfully") }
      end
    end
  end
end
