# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User show template" do
  before do
    sign_in(user)
    visit user_path(user)
  end

  # * Admins & Members
  describe "visited by 'Admin' & 'Member'" do
    let(:user) { create(:user_admin_or_member) }

    it { expect(page).to have_title "User: #{user.name}" }

    it "shows user name, ITS and their role" do
      within("#user") do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.its)
        expect(page).to have_content(user.role.capitalize)
      end
    end

    describe "action buttons" do
      it_behaves_like "show_edit_delete"
    end
  end

  # * Viewer
  describe "visited by 'Viewer'" do
    let(:user) { create(:viewer_user) }

    it "redirects to default path with not authorized message" do
      expect(page).to (have_current_path thaalis_all_path(CURR_YR)).and have_content("Not Authorized")
    end
  end
end
