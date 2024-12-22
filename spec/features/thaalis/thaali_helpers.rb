# shared_examples "view thaali records" do
#   it "thaali number, balance and sabeel name", :js do
#     thaalis.each do
#       expect(page).to have_content(_1.number)
#       expect(page).to have_content(_1.sabeel_name)
#       expect(page).to have_content(number_to_human(_1.balance, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"}))
#     end
#   end
# end
