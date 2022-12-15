require "rails_helper"

RSpec.describe Sabeel, type: model do
    context "validation tests" do
        context "of ITS attribute" do
            it "must be numerical"

            it "must have a length of exactly 8 digits"

            it "must be unique"

            it "cannot be null"
        end

        context "of Email attribute" do
            it "must be in a valid format"
        end

        context "of HOF name" do
            it "cannot be null"

            it "must be unique"
        end

        context "of Address attribute" do
            it "cannot be null"

            it "must be in a specific format"
        end

        context "of Mobile attribute" do
            it "must be numerical"

            it "must have a length of exactly 10 digits"

            it "cannot be null"
        end

        context "of Mobile attribute" do
            it "must be a boolean "
        end

        context "of Mobile attribute" do
            it "should default to false after creating a sabeel instance"
        end
    end
end