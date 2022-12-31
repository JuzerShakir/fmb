require "rails_helper"

RSpec.describe "Transaction features"do
    before do
        @sabeel = FactoryBot.create(:sabeel)
        @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
        @transaction = FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali.id)
    end

    context "create a Transaction" do
        before do
            @attributes = FactoryBot.attributes_for(:transaction)

            visit takhmeen_path(@thaali)

            click_button "New Transaction"
            expect(current_path).to eql new_takhmeen_transaction_path(@thaali)

            expect(page).to have_css('h2', text: "New Transaction")
            @select_atr = @attributes.extract!(:mode, :on_date)

            @attributes.each do |k, v|
                fill_in "transaction_#{k}",	with: "#{v}"
            end
        end

        scenario "with valid values" do
            select @select_atr.fetch(:mode).to_s.titleize, from: :transaction_mode

            click_button "Create Transaction"

            trans = Transaction.last

            expect(current_path).to eql transaction_path(trans)
            expect(page).to have_content("Transaction created successfully")
        end

        scenario "with invalid values" do
            click_button "Create Transaction"

            expect(page).to have_content("Please review the problems below:")
            expect(page).to have_content("Mode must be selected")
        end
    end

    context "Editing Transaction" do
        before do
            visit transaction_path(@transaction)
        end

        it "should have an edit link" do
            expect(page).to have_button("Edit Transaction")
        end

        scenario "should BE able to update with valid values" do
            click_button "Edit Transaction"
            fill_in "transaction_amount", with: Faker::Number.number(digits: 4)

            click_on "Update Transaction"
            expect(current_path).to eql transaction_path(@transaction)
            expect(page).to have_content("Transaction updated successfully")
        end
    end

    scenario "Showing transaction" do
        visit transaction_path(@transaction)
        expect(page).to have_content("#{@transaction.recipe_no}")
        expect(page).to have_content("#{@transaction.amount}")
        expect(page).to have_content("#{@transaction.on_date.to_time.strftime('%A, %b %d %Y')}")
        expect(page).to have_content("#{@transaction.mode.humanize}")
    end

    scenario "Deleting transaction" do
        visit transaction_path(@transaction)
        expect(page).to have_button("Delete Transaction")

        click_on "Delete Transaction"
        click_on "Yes, delete it!"

        expect(current_path).to eql takhmeen_path(@thaali)
        expect(page).to have_content("Transaction destroyed successfully")
    end
end