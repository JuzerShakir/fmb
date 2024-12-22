shared_examples "view sabeel records" do
  it "name & apartment", :js do
    sabeels.each do
      expect(page).to have_content(_1.name).and have_content(_1.apartment.titleize)
    end
  end
end

shared_examples "view thaali records" do
  it "thaali number, balance and sabeel name", :js do
    thaalis.each do
      expect(page).to have_content(_1.number)
      expect(page).to have_content(_1.sabeel_name)
      expect(page).to have_content(number_to_human(_1.balance, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"}))
    end
  end
end

shared_examples "view transaction records" do
  it "receipt number, amount & date" do
    transactions.each do
      expect(page).to have_content(_1.receipt_number)
      expect(page).to have_content(number_to_human(_1.amount, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"}))
      expect(page).to have_content(time_ago_in_words(_1.date))
    end
  end
end

shared_examples "abbreviated numbers" do
  it { expect(page).to have_content(number_to_human(number, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"})) }
end

shared_examples "hide_edit_delete" do
  it do
    expect(page).to have_no_link("Edit").and have_no_button("Delete")
  end
end

shared_examples "show_edit_delete" do
  it do
    expect(page).to have_link("Edit").and have_button("Delete")
  end
end
