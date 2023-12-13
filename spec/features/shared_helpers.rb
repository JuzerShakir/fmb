shared_examples "abbreviated numbers" do
  it { expect(page).to have_content(number_to_human(number, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"})) }
end