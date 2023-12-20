# frozen_string_literal: true

require "rails_helper"
require_relative "thaali_helpers"

RSpec.describe "Thaali all template" do
  let(:user) { create(:user) }
  let(:thaalis) { Thaali.first(2) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:took_thaali, 2)

    visit thaalis_all_path(PREV_YR)
  end

  # * ALL user types
  describe "visited by any user type can", :js do
    it { expect(page).to have_title "Thaalis in #{PREV_YR}" }

    it_behaves_like "view thaali records"
  end
end
