# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Index template" do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    create_list(:sabeel, 2)
    visit sabeels_path
  end

  # * ALL user types
  describe "visited by any user type" do
    let(:sabeels) { Sabeel.first(2) }

    it { expect(page).to have_title "Sabeels" }

    it_behaves_like "view sabeel records"

    describe "can search", :js do
      let(:sabeel_a) { Sabeel.first }
      let(:sabeel_b) { Sabeel.last }

      context "with ITS" do
        before { fill_in "q_slug_or_name_cont", with: sabeel_a.its }

        it "returns sabeel with that ITS" do
          within("section#sabeels") do
            expect(page).to have_content(sabeel_a.name)
            expect(page).to have_no_content(sabeel_b.name)
          end
        end
      end

      context "with name" do
        before { fill_in "q_slug_or_name_cont", with: sabeel_b.name }

        it "returns sabeel with that name" do
          within("section#sabeels") do
            expect(page).to have_content(sabeel_b.name)
            expect(page).to have_no_content(sabeel_a.name)
          end
        end
      end
    end
  end
end
