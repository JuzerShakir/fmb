Sabeel.destroy_all

apartments = Sabeel.apartments.keys
sizes = ThaaliTakhmeen.sizes.keys
modes = Transaction.modes.keys

#  CREATE SABEEL
100.times do |i|
  Sabeel.create(
    its: 10000000 + i,
    name: Faker::Name.name,
    apartment: apartments.sample,
    flat_no: Faker::Number.within(range: 1..9999),
    mobile: Faker::Number.number(digits: 10),
    email: Faker::Internet.free_email
  )
end

#  90% of sabeels have taken thaali in previous year  -->  (90 sabeels meaning 90 thaalis of prev year)
sabeel_prev_thaali = Sabeel.all.sample(Sabeel.count * 0.9)

sabeel_prev_thaali.each.with_index do |sabeel, i|
  sabeel.thaali_takhmeens.create(
    year: PREV_YR,
    total: 48000,
    number: i + 1,
    size: sizes.sample
  )
end

#  have 80% of thaalis to have a complete payment of prev year --> (864 transactions from 72 thaalis)
prev_takhmeen_comp = ThaaliTakhmeen.in_the_year(PREV_YR).sample(sabeel_prev_thaali.count * 0.8)

prev_takhmeen_comp.each do |thaali|
  12.times do
    thaali.transactions.create(
      amount: 4000,
      date: Faker::Date.in_date_period(year: PREV_YR),
      recipe_no: Random.rand(1..2000000),
      mode: modes.sample
    )
  end
end

#  have rest of the thaalis created of prev year be pending  ---> (maximum: 198 transactions from 18 thaalis)
prev_takhmeen_pend = ThaaliTakhmeen.pending_year(PREV_YR)

prev_takhmeen_pend.each do |thaali|
  num = Random.rand(1...12)
  num.times do
    thaali.transactions.create(
      amount: 4000,
      date: Faker::Date.in_date_period(year: PREV_YR),
      recipe_no: Random.rand(2000001..3000000),
      mode: modes.sample
    )
  end
end

#  95% of sabeels have had taken thaali in previous year are continuing in current year --> (85 thaali of 85 sabeels)
active_sabeel = sabeel_prev_thaali.sample(sabeel_prev_thaali.count * 0.95)

active_sabeel.each.with_index do |sabeel, i|
  sabeel.thaali_takhmeens.create(
    year: CURR_YR,
    total: 60000,
    number: i + 1,
    size: sizes.sample
  )
end

#  have ~30% thaalis complete the takhmeens of current year but only if their last year takhmeen is complete ---> (maximum thaalis: 25 thaalis)
cur_takhmeen_comp = ThaaliTakhmeen.in_the_year(CURR_YR).sample(active_sabeel.count * 0.3)

cur_takhmeen_comp.each do |thaali|
  if thaali.sabeel.takhmeen_complete_of_last_year?
    12.times do
      thaali.transactions.create(
        amount: 5000,
        date: Faker::Date.in_date_period(year: CURR_YR),
        recipe_no: Random.rand(3000001..6000000),
        mode: modes.sample
      )
    end
  end
end

#  have takhmeen pending for rest (~70%) of the thaalis created of current year
cur_takhmeen_pend = ThaaliTakhmeen.pending_year(CURR_YR)

cur_takhmeen_pend.each do |thaali|
  num = Random.rand(1...12)
  num.times do
    thaali.transactions.create(
      amount: 5000,
      date: Faker::Date.in_date_period(year: CURR_YR),
      recipe_no: Random.rand(6000000..10000000),
      mode: modes.sample
    )
  end
end

# *CREATES TOTAL Sabeel --> 1000
# *CREATES TOTAL ThaaliTakhmeens --> 1755 (900 + 855)
# *CREATES TOTAL Transactions --> ~16k
