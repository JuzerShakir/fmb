# frozen_string_literal: true

require "rails_helper"
require_relative "sabeel_helpers"

RSpec.describe "Sabeel Index template" do
  let(:user) { create(:user) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:sabeel, 2)
    visit sabeels_path
  end

  # * ALL user types
  describe "visited by any user type", :js do
    let(:sabeels) { Sabeel.first(2) }

    it { expect(page).to have_title "Sabeels" }

    it_behaves_like "view sabeel records"

    describe "can search with ITS" do
      let(:first) { Sabeel.first }
      let(:last) { Sabeel.last }

      before { fill_in "q_slug_start", with: first.its }

      it { within("div#sabeels") { expect(page).to have_content(first.its) } }
      it { within("div#sabeels") { expect(page).not_to have_content(last.its) } }
    end
  end
end
