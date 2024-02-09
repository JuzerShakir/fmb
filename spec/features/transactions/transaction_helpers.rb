shared_examples "view transaction records" do
  it "receipt number" do
    transactions.each { expect(page).to have_content(_1.receipt_number) }
  end

  it "amount" do
    transactions.each { expect(page).to have_content(number_to_human(_1.amount, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"})) }
  end

  it "date" do
    transactions.each { expect(page).to have_content(time_ago_in_words(_1.date)) }
  end
end
