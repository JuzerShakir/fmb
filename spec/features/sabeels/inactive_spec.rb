# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Inactive template" do
  let(:user) { create(:user) }
  let!(:sabeel) { create(:burhani_sabeel_with_previous_takhmeen) }

  before do
    page.set_rack_session(user_id: user.id)
    visit sabeels_inactive_path("burhani")
  end

  # * ALL user types
  describe "visited by any user type", :js do
    describe "shows inactive sabeel details" do
      it { expect(page).to have_content(sabeel.name) }
      it { expect(page).to have_content(sabeel.its) }
    end
  end
end
