FactoryBot.define do
  factory :thaali do
    sabeel
    sequence(:number, 1)
    sequence :size, %i[small medium large].cycle
  end
end
