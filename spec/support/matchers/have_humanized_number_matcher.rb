# frozen_string_literal: true

RSpec::Matchers.define :have_humanized_number do |expected_value|
  humanized_number = expected_value.to_human

  match do
    _1.body.include? humanized_number
  end

  match_when_negated do
    _1.to_s.exclude? humanized_number
  end

  failure_message do |actual|
    "expected that #{actual.body} would include '#{humanized_number}'"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not include '#{humanized_number}'"
  end
end
