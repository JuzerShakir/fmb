shared_examples "view thaali records" do
  it "thaali number" do
    thaalis.each { expect(page).to have_content(_1.number) }
  end

  it "name" do
    thaalis.each { expect(page).to have_content(_1.sabeel_name) }
  end

  it "balance" do
    thaalis.each { expect(page).to have_content(number_to_human(_1.balance, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"})) }
  end
end
