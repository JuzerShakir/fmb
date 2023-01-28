require "rails_helper"

RSpec.describe "Transaction features"do
    before do
        @user = FactoryBot.create(:user)
        page.set_rack_session(user_id: @user.id)
        visit root_path

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

    # * INDEX
    context "index template", js: true do
        before do
            @transactions = FactoryBot.create_list(:transaction, 3)
            visit all_transactions_path
        end

        scenario "should have a link to recipe_no button that renders transaction:show page after clicking it" do
            @transactions.each do |tran|
                recipe_no = tran.recipe_no
                expect(page).to have_content("#{recipe_no}")

                click_button "#{recipe_no}"
                expect(current_path).to eql transaction_path(tran)
                page.driver.go_back
            end
        end

        scenario "should show 'amount', 'thaali_number' & 'on_date' of all transactions" do
            @transactions.each do |tran|
                expect(page).to have_content("#{tran.amount}")
                expect(page).to have_content("#{time_ago_in_words(tran.on_date)}")
                thaali = tran.thaali_takhmeen
                expect(page).to have_content("#{thaali.number}")
            end
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
            expect(page).to have_link("Edit")
        end

        scenario "should display correct maximum amount in the hint message" do
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

        context "with invalid values", js: true do
            before do
                @total = @thaali.balance + @transaction.amount
                incorrect_amount = @total + Random.rand(1..100)
                fill_in "transaction_amount", with: incorrect_amount

                click_on "Update Transaction"
            end

            scenario "should NOT be able to update transaction" do
                expect(current_path).to eql edit_transaction_path(@transaction)
                within(".transaction_amount") do
                    expect(page).to have_content("Amount cannot be greater than the balance")
                end
            end

            scenario "should display correct maximum amount in the hint message after passing incorrect amount" do
                within(".transaction_amount") do
                    expect(page).to have_css('small', text: "Amount shouldn't be greater than: #{@total.humanize}")
                end
            end
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
        expect(page).to have_button("Delete")

        click_on "Delete"
        click_on "Yes, delete it!"

        expect(current_path).to eql takhmeen_path(@thaali)
        expect(page).to have_content("Transaction destroyed successfully")
    end
end