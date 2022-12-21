require "rails_helper"

RSpec.describe ThaaliTakhmeen, type: :model do
    today = Date.today
    yesterday = Date.today.prev_day
    current_year = today.year
    next_year = today.next_year.year

    context "association" do
        it { should belong_to(:sabeel) }
    end
end
