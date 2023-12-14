shared_examples "view sabeel records" do
  it "ITS number" do
    sabeels.each { expect(page).to have_content(_1.its) }
  end

  it "name" do
    sabeels.each { expect(page).to have_content(_1.name) }
  end

  it "apartment" do
    sabeels.each { expect(page).to have_content(_1.apartment.titleize) }
  end
end
