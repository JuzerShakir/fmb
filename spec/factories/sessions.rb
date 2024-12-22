# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    user
    ip_address { Faker::Internet.public_ip_v4_address }
    user_agent { Faker::Internet.user_agent }
  end
end
