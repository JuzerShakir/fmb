shared_examples "view thaali records" do
  it "thaali number" do
    thaalis.each do |thaali|
      expect(page).to have_content(thaali.number)
    end
  end

  it "name" do
    thaalis.each do |thaali|
      expect(page).to have_content(thaali.sabeel.name)
    end
  end

  it "balance" do
    thaalis.each do |thaali|
      expect(page).to have_content(number_to_human(thaali.balance, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"}))
    end
  end
end
