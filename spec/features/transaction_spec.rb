require "rails_helper"

RSpec.describe "Transaction accessed by users who are 👉" do
    before do
        @thaali = FactoryBot.create(:thaali_takhmeen)
        @transaction = FactoryBot.create(:transaction, thaali_takhmeen_id: @thaali.id)

        # manually setting new balance amount since callback methods are not called
        @thaali.balance -= @transaction.amount
    end

    # * NON-LOGGED-IN users
    context "not-logged-in will NOT render template" do
        scenario "'new'" do
            visit new_takhmeen_transaction_path(@thaali)
            expect(current_path).to eq login_path
            expect(page).to have_content "Not Authorized!"
        end

        scenario "'show'" do
            visit transaction_path(@transaction)
            expect(current_path).to eq login_path
            expect(page).to have_content "Not Authorized!"
        end

        scenario "'edit'" do
            visit edit_transaction_path(@transaction)
            expect(current_path).to eq login_path
            expect(page).to have_content "Not Authorized!"
        end

        scenario "'index'" do
            visit all_transactions_path
            expect(current_path).to eq login_path
            expect(page).to have_content "Not Authorized!"
        end
    end

    # * ALL user types
    context "logged-in WILL render template" do
        before do
            @user = FactoryBot.create(:user)
            page.set_rack_session(user_id: @user.id)
            visit root_path
        end

        # * SHOW
        context "'show' should have" do
            before do
                visit transaction_path(@transaction)
            end

            scenario "an 'edit' link" do
                expect(page).to have_link("Edit")
            end

            scenario "a 'delete' link" do
                expect(page).to have_button("Delete")
            end

            scenario "'recipe_no', 'amount', 'date' & 'mode' details" do
                expect(page).to have_content("#{@transaction.recipe_no}")
                expect(page).to have_content("#{@transaction.amount}")
                expect(page).to have_content("#{@transaction.date.to_time.strftime('%A, %b %d %Y')}")
                expect(page).to have_content("#{@transaction.mode.humanize}")
            end
        end

        # * INDEX
        context "'index' should have", js: true do
            before do
                @transactions = FactoryBot.create_list(:transaction, 3)
                visit all_transactions_path
            end

            scenario "a header" do
                expect(page).to have_css('h2', text: "Transactions")
            end

            scenario "'recipe_no' button that routes to transaction:show page" do
                @transactions.each do |tran|
                    recipe_no = tran.recipe_no
                    expect(page).to have_content("#{recipe_no}")

                    click_button "#{recipe_no}"
                    expect(current_path).to eql transaction_path(tran)
                    page.driver.go_back
                end
            end

            scenario "'amount', 'thaali_number' & 'date' details of all transactions" do
                @transactions.each do |tran|
                    expect(page).to have_content("#{tran.amount}")
                    expect(page).to have_content("#{time_ago_in_words(tran.date)}")
                    thaali = tran.thaali_takhmeen
                    expect(page).to have_content("#{thaali.number}")
                end
            end

            context "search that returns transactions with the" do
                scenario "recipe_no searched for" do
                  searched_recipe_no = @transactions.first.recipe_no
                  un_searched_recipe_no = @transactions.last.recipe_no

                  fill_in "q_recipe_no_cont", with: "#{searched_recipe_no}"

                  within('div#all-transactions') do
                    expect(page).to have_content(searched_recipe_no)
                    expect(page).not_to have_content(un_searched_recipe_no)
                  end

                end
            end
        end
    end

    # * ONLY Admins & Members
    context "'Admin' & 'Member' WILL render template" do
        before do
            @user = FactoryBot.create(:user_other_than_viewer)
            page.set_rack_session(user_id: @user.id)
            visit root_path
        end

        # * NEW
        context "'new'" do
            scenario "shows correct url and a heading" do
                visit takhmeen_path(@thaali)
                click_button "New Transaction"

                expect(current_path).to eql new_takhmeen_transaction_path(@thaali)
                expect(page).to have_css('h2', text: "New Transaction")
            end
        end

        # * CREATE
        context "creating transaction" do
            before do
                visit new_takhmeen_transaction_path(@thaali)

                @attributes = FactoryBot.attributes_for(:transaction)
                @select_atr = @attributes.extract!(:mode, :date)

                @attributes.each do |k, v|
                    fill_in "transaction_#{k}",	with: "#{v}"
                end
            end

            scenario "shows a hint for 'amount' attribute" do
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
        context "'edit'" do
            before do
                @total = @thaali.balance + @transaction.amount
                visit edit_transaction_path(@transaction)
            end

            scenario "should display correct maximum amount in the hint message" do
                within(".transaction_amount") do
                    expect(page).to have_css('small', text: "Amount shouldn't be greater than: #{@total.humanize}")
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

        # * DELETE
        context "'destroy'", js: true do
            before do
                visit transaction_path(@transaction)
                click_on "Delete"
            end

            context "clicking on delete button" do
                scenario "opens a destroy modal" do
                    expect(page).to have_css("#destroyModal")
                end

                scenario "shows confirmation heading" do
                    within(".modal-header") do
                        expect(page).to have_css('h1', text: 'Confirm Deletion')
                    end
                end

                scenario "shows confirmation message" do
                    within(".modal-body") do
                        expect(page).to have_content("Are you sure you want to delete Transaction reciepe no: #{@transaction.recipe_no}? This action cannot be undone.")
                    end
                end

                scenario "show action buttons" do
                    within(".modal-footer") do
                        expect(page).to have_css(".btn-secondary", text: "Cancel")
                        expect(page).to have_css(".btn-primary", text: "Yes, delete it!")
                    end
                end
            end

            context "after clicking 'Yes, delete it!' button" do
                before do
                    click_on "Yes, delete it!"
                end

                scenario "returns to root path" do
                    expect(current_path).to eql takhmeen_path(@thaali)
                end

                scenario "shows success flash message" do
                    expect(page).to have_content("Transaction destroyed successfully")
                end
            end
        end
    end

    # * NOT ACCESSED by Viewers
    context "'Viewer' will NOT render template" do
        before do
            @viewer = FactoryBot.create(:viewer_user)
            page.set_rack_session(user_id: @viewer.id)
            visit transaction_path(@transaction)
        end

        scenario "'new'" do
            visit takhmeen_path(@thaali)
            click_on "New Transaction"
            expect(current_path).to eq takhmeen_path(@thaali)
            expect(page).to have_content "Not Authorized!"
        end

        scenario "'edit'" do
            click_on "Edit"
            expect(current_path).to eq  transaction_path(@transaction)
            expect(page).to have_content "Not Authorized!"
        end

        scenario "destroy" do
            click_on "Delete"
            click_on "Yes, delete it!"
            expect(current_path).to eq transaction_path(@transaction)
            expect(page).to have_content "Not Authorized!"
        end
    end
end