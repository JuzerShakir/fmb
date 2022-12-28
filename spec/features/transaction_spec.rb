require "rails_helper"

RSpec.describe "Transaction features"do
    context "create a Transaction" do
        before do
            @sabeel = FactoryBot.create(:sabeel)
            @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
            @attributes = FactoryBot.attributes_for(:transaction)

            visit(sabeel_path(@sabeel.slug))

            click_link "New Transaction"
            expect(current_path).to eql(new_takhmeen_transaction_path(@thaali.slug))

            expect(page).to have_css('h1', text: "New Transaction")
            @select_atr = @attributes.extract!(:mode, :on_date)

            @attributes.each do |k, v|
                fill_in "transaction_#{k}",	with: "#{v}"
            end
        end

        scenario "with valid values" do
            select @select_atr.fetch(:mode).to_s.titleize, from: :transaction_mode

            click_button "Create Transaction"

            trans = Transaction.last

            expect(current_path).to eql("/transactions/#{trans.slug}")
            expect(page).to have_content("Transaction created successfully")
        end

        scenario "with invalid values" do
            click_button "Create Transaction"

            expect(page).to have_content("Please review the problems below:")
            expect(page).to have_content("Mode must be selected")
        end
    end
end