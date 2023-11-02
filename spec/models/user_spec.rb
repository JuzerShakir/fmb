# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject(:user) { build(:user) }

  context "when validating" do
    context "with password" do
      it { is_expected.to validate_length_of(:password).is_at_least(6).with_short_message("must be more than 6 characters") }
      it { is_expected.to validate_length_of(:password_confirmation).is_at_least(6).with_short_message("must be more than 6 characters") }
    end

    context "with roles" do
      before do
        user.role_ids = ""
        user.save
      end

      it { expect(user.errors[:role_ids]).to contain_exactly("selection is required") }
    end
  end
end
