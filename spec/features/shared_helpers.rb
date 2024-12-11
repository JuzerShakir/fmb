shared_examples "abbreviated numbers" do
  it { expect(page).to have_content(number_to_human(number, precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"})) }
end

shared_examples "hide_edit_delete" do
  it { expect(page).to have_no_link("Edit") }
  it { expect(page).to have_no_button("Delete") }
end

shared_examples "show_edit_delete" do
  it { expect(page).to have_link("Edit") }
  it { expect(page).to have_button("Delete") }
end
