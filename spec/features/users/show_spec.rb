# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User show template" do
  let(:user) { create(:user_other_than_viewer) }

  before do
    page.set_rack_session(user_id: user.id)
    visit user_path(user)
  end

  # * Admins & Members
  describe "visited by 'Admin' & 'Member'" do
    describe "can view" do
      describe "user details" do
        it { within("#show-user") { expect(page).to have_content(user.name) } }
        it { within("#show-user") { expect(page).to have_content(user.its) } }
        it { within("#show-user") { expect(page).to have_content(user.role.humanize) } }
      end

      describe "action buttons" do
        it { expect(page).to have_link("Edit") }
        it { expect(page).to have_button("Delete") }
      end
    end
  end
end
