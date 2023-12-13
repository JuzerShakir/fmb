shared_examples "view transaction records" do
  it "recipe number" do
    transactions.each do |transaction|
      expect(page).to have_content(transaction.recipe_no)
    end
  end

  it "amount" do
    transactions.each do |transaction|
      expect(page).to have_content(number_to_human(transaction.amount, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"}))
    end
  end

  it "date" do
    transactions.each do |transaction|
      expect(page).to have_content(time_ago_in_words(transaction.date))
    end
  end
end
