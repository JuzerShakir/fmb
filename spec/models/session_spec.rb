# frozen_string_literal: true

require "rails_helper"

RSpec.describe Session do
  subject(:session) { build(:session) }

  context "with associations" do
    it { is_expected.to belong_to(:user) }
  end
end
