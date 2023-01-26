Sabeel.destroy_all

#  CREATE SABEEL
1000.times do | i |
    Sabeel.create(
        its: 10000000 + i,
        hof_name: Faker::Name.name,
        apartment: Array.new.push(*$phase_1, *$phase_2, *$phase_3).sample,
        flat_no: Faker::Number.within(range: 1..9999),
        mobile: Faker::Number.number(digits: 10),
        email: Faker::Internet.free_email
    )
end


#  90% of sabeels have taken thaali in previous year  -->  (900 sabeels, 900 prev thaali)
sabeel_prev_thaali = Sabeel.all.sample(Sabeel.count * 0.9)

sabeel_prev_thaali.each.with_index do |sabeel, i|
    sabeel.thaali_takhmeens.create(
        year: $prev_takhmeen,
        total: 48000,
        number: i + 1,
        size: %w(large small medium).sample
    )
end

#  have 80% of thaalis to have a complete payment of prev year --> (8640 transactions from 720 thaalis)
prev_takhmeen_comp = ThaaliTakhmeen.in_the_year($prev_takhmeen).sample(sabeel_prev_thaali.count * 0.8)

prev_takhmeen_comp.each do |thaali|
    12.times do
        thaali.transactions.create(
            amount: 4000,
            on_date: Faker::Date.in_date_period(year: $prev_takhmeen),
            recipe_no: Random.rand(1..2000000),
            mode: %w(cash bank cheque).sample
        )
    end
end


#  have rest of the thaalis created of prev year be pending  ---> (maximum: 1980 transactions from 180 thaalis)
prev_takhmeen_pend = ThaaliTakhmeen.pending_year($prev_takhmeen)

prev_takhmeen_pend.each do |thaali|
    num = Random.rand(1...12)
    num.times do
        thaali.transactions.create(
            amount: 4000,
            on_date: Faker::Date.in_date_period(year: $prev_takhmeen),
            recipe_no: Random.rand(2000001..3000000),
            mode: %w(cash bank cheque).sample
        )
    end
end


#  95% of sabeels have had taken thaali in previous year are continuing in current year --> (855 thaali of 855 sabeels)
active_sabeel = sabeel_prev_thaali.sample(sabeel_prev_thaali.count * 0.95)

active_sabeel.each.with_index do |sabeel, i|
    sabeel.thaali_takhmeens.create(
        year: $active_takhmeen,
        total: 60000,
        number: i + 1,
        size: %w(large small medium).sample
    )
end


#  have ~30% thaalis complete the takhmeens of current year but only if their last year takhmeen is complete ---> (maximum thaalis: 256 thaalis)
cur_takhmeen_comp = ThaaliTakhmeen.in_the_year($active_takhmeen).sample(active_sabeel.count * 0.3)

cur_takhmeen_comp.each do |thaali|
    if thaali.sabeel.takhmeen_complete_of_last_year($active_takhmeen)
        12.times do
            thaali.transactions.create(
                amount: 5000,
                on_date: Faker::Date.in_date_period(year: $active_takhmeen),
                recipe_no: Random.rand(3000001..6000000),
                mode: %w(cash bank cheque).sample
            )
        end
    end
end

#  have takhmeen pending for rest (~70%) of the thaalis created of current year
cur_takhmeen_pend = ThaaliTakhmeen.pending_year($active_takhmeen)

cur_takhmeen_pend.each do |thaali|
    num = Random.rand(1...12)
    num.times do
        thaali.transactions.create(
            amount: 5000,
            on_date: Faker::Date.in_date_period(year: $active_takhmeen),
            recipe_no: Random.rand(6000000..10000000),
            mode: %w(cash bank cheque).sample
        )
    end
end

# *CREATES TOTAL Sabeel --> 1000
# *CREATES TOTAL ThaaliTakhmeens --> 1755 (900 + 855)
# *CREATES TOTAL Transactions --> ~16k