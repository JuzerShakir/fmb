FactoryBot.define do
  factory :thaali do
    sabeel
    number { Random.rand(1..1000) }
    sequence :size, %i[small medium large].cycle
  end
end
