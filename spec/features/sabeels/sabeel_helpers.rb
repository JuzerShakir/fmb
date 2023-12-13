shared_examples "view sabeel records" do
  it "ITS number" do
    sabeels.each do |sabeel|
      expect(page).to have_content(sabeel.its)
    end
  end

  it "name" do
    sabeels.each do |sabeel|
      expect(page).to have_content(sabeel.name)
    end
  end

  it "apartment" do
    sabeels.each do |sabeel|
      expect(page).to have_content(sabeel.apartment.titleize)
    end
  end
end
