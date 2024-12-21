# frozen_string_literal: true

require "rails_helper"
require_relative "sabeel_helpers"

RSpec.describe "Sabeel Index template" do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    create_list(:sabeel, 2)
    visit sabeels_path
  end

  # * ALL user types
  describe "visited by any user type", :js do
    let(:sabeels) { Sabeel.first(2) }

    it { expect(page).to have_title "Sabeels" }

    it_behaves_like "view sabeel records"

    describe "can search" do
      let(:first) { Sabeel.first }
      let(:last) { Sabeel.last }

      context "with ITS" do
        before { fill_in "q_slug_or_name_cont", with: first.its }

        it { within("section#sabeels") { expect(page).to have_content(first.name) } }
        it { within("section#sabeels") { expect(page).to have_no_content(last.name) } }
      end

      context "with name" do
        before { fill_in "q_slug_or_name_cont", with: last.name }

        it { within("section#sabeels") { expect(page).to have_content(last.name) } }
        it { within("section#sabeels") { expect(page).to have_no_content(first.name) } }
      end
    end
  end
end
