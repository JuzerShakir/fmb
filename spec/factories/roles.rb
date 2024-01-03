FactoryBot.define do
  factory :role do
    name { Role::NAMES.sample }

    # * Factories
    factory :admin do
      name { "admin" }
    end

    factory :member do
      name { "member" }
    end

    factory :viewer do
      name { "viewer" }
    end

    factory :member_or_viewer do
      name { ["member", "viewer"].sample }
    end

    factory :admin_or_member do
      name { ["admin", "member"].sample }
    end
  end
end
