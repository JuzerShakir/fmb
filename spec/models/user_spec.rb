# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject(:user) { build(:user) }

  context "when validating" do
    context "with password" do
      it { is_expected.to validate_length_of(:password).is_at_least(6).with_short_message("must be more than 6 characters") }
      it { is_expected.to validate_length_of(:password_confirmation).is_at_least(6).with_short_message("must be more than 6 characters") }
    end

    context "with role" do
      it { is_expected.to validate_presence_of(:role).with_message("selection is required") }

      it { is_expected.to define_enum_for(:role).with_values([:admin, :member, :viewer]) }
    end
  end
end
