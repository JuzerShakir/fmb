# frozen_string_literal: true

require "rails_helper"
require_relative "../shared_helpers"

RSpec.describe "User show template" do
  before do
    page.set_rack_session(user_id: user.id)
    visit user_path(user)
  end

  # * Admins & Members
  describe "visited by 'Admin' & 'Member'" do
    let(:user) { create(:user_admin_or_member) }

    it { expect(page).to have_title "User: #{user.name}" }

    describe "can view" do
      describe "user details" do
        it { within("#user") { expect(page).to have_content(user.name) } }
        it { within("#user") { expect(page).to have_content(user.its) } }
        it { within("#user") { expect(page).to have_content(user.role.capitalize) } }
      end

      describe "action buttons" do
        it_behaves_like "show_edit_delete"
      end
    end
  end

  # * Viewer
  describe "visited by 'Viewer'" do
    let(:user) { create(:viewer_user) }

    it { expect(page).to have_content("Not Authorized") }
    it { expect(page).to have_current_path thaalis_all_path(CURR_YR) }
  end
end
