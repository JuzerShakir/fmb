require "rails_helper"

RSpec.describe "Transaction features"do
    before do
        @sabeel = FactoryBot.create(:sabeel)
        @thaali = FactoryBot.create(:thaali_takhmeen, sabeel_id: @sabeel.id)
    end

    # * CREATE
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

        scenario "should display balance amount of thaali" do
            within(".transaction_amount") do
                expect(page).to have_css('small', text: "Amount shouldn't be greater than: #{@thaali.balance.humanize}")
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

    # * EDIT
    context "Editing Transaction" do
        before do
            @transaction = FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali.id)
            # manually setting new balance amount since callback methods are not called
            @thaali.balance -= @transaction.amount

            visit edit_transaction_path(@transaction)
        end

        it "should have an edit link" do
            visit transaction_path(@transaction)
            expect(page).to have_link("Edit Transaction")
        end

        scenario "should display amount of both the balance & current transaction amount" do
            total = @thaali.balance + @transaction.amount

            within(".transaction_amount") do
                expect(page).to have_css('small', text: "Amount shouldn't be greater than: #{total.humanize}")
            end
        end

        scenario "should BE able to update with valid values" do
            fill_in "transaction_amount", with: Faker::Number.number(digits: 4)

            click_on "Update Transaction"
            expect(current_path).to eql transaction_path(@transaction)
            expect(page).to have_content("Transaction updated successfully")
        end
    end

    # * SHOW
    scenario "Showing transaction" do
        @transaction = FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali.id)

        visit transaction_path(@transaction)
        expect(page).to have_content("#{@transaction.recipe_no}")
        expect(page).to have_content("#{@transaction.amount}")
        expect(page).to have_content("#{@transaction.on_date.to_time.strftime('%A, %b %d %Y')}")
        expect(page).to have_content("#{@transaction.mode.humanize}")
    end

    # * DESTROY
    scenario "Deleting transaction" do
        @transaction = FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali.id)

        visit transaction_path(@transaction)
        expect(page).to have_button("Delete Transaction")

        click_on "Delete Transaction"
        click_on "Yes, delete it!"

        expect(current_path).to eql takhmeen_path(@thaali)
        expect(page).to have_content("Transaction destroyed successfully")
    end
end