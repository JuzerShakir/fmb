Sabeel.destroy_all

def set_transaction(num, th_id, amt, min, max, dt)
    FactoryBot.create_list(:transaction, num,
        thaali_takhmeen_id: th_id,
        amount: amt,
        recipe_no: Random.rand(min..max),
        on_date: dt
    )
end

#  CREATE SABEEL
1000.times do | i |
    FactoryBot.create(:sabeel, its: 10000000 + 1)
end

#  90% of sabeels have taken thaali in previous year  -->  (900 sabeels, 900 prev thaali)
sabeel_prev_thaali = Sabeel.all.sample(Sabeel.count * 0.9)

sabeel_prev_thaali.each.with_index do |sabeel, i|
    FactoryBot.create(:previous_takhmeen, total: 48000, number: i + 1, sabeel_id: sabeel.id)
end


#  have 80% of thaalis to have a complete payment of prev year --> (8640 transactions from 720 thaalis)
prev_takhmeen_comp = ThaaliTakhmeen.in_the_year($prev_takhmeen).sample(sabeel_prev_thaali.count * 0.8)

prev_takhmeen_comp.each do |thaali|
    set_transaction(12, thaali.id, 4000, 1, 2000000, $prev_takhmeen)
end


#  have rest of the thaalis created of prev year be pending  ---> (maximum: 1980 from 180 thaalis)
prev_takhmeen_pend = ThaaliTakhmeen.pending_year($prev_takhmeen)

prev_takhmeen_pend.each do |thaali|
    num = Random.rand(1...12)
    set_transaction(num, thaali.id, 4000, 2000001, 3000000, $prev_takhmeen)
end


#  95% of sabeels have had taken thaali in previous year are continuing in current year --> (855 thaali, 855 sabeels)
active_sabeel = sabeel_prev_thaali.sample(sabeel_prev_thaali.count * 0.95)

active_sabeel.each.with_index do |sabeel, i|
    FactoryBot.create(:active_takhmeen, total: 60000, number: i + 1, sabeel_id: sabeel.id)
end


#  have ~30% thaalis complete the takhmeens of current year but only if their last year takhmeen is complete ---> (maximum thaalis: 256 thaalis)
cur_takhmeen_comp = ThaaliTakhmeen.in_the_year($active_takhmeen).sample(active_sabeel.count * 0.3)

cur_takhmeen_comp.each do |thaali|
    if thaali.sabeel.takhmeen_complete_of_last_year($active_takhmeen)
        set_transaction(12, thaali.id, 5000, 3000001, 6000000, $active_takhmeen)
    end
end


#  have rest (~70%) of the thaalis created of current year be pending
cur_takhmeen_pend = ThaaliTakhmeen.pending_year($active_takhmeen)

cur_takhmeen_pend.each do |thaali|
    num = Random.rand(1...12)
    set_transaction(num, thaali.id, 5000, 6000000, 10000000, $active_takhmeen)
end