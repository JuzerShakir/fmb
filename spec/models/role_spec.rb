# frozen_string_literal: true

require "rails_helper"

RSpec.describe Role do
  subject(:role) { build(:role) }

  context "when validating" do
    context "with name" do
      it { is_expected.to validate_presence_of(:name).with_message("selection is required") }

      it { is_expected.to validate_inclusion_of(:name).in_array(Role::NAMES) }
    end
  end
end
