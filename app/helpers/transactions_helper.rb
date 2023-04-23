module TransactionsHelper
  def readable_date(date)
    date.to_time.strftime("%A, %b %d %Y")
  end

  def amount_message
    "Amount shouldn't be greater than: #{@total_balance}"
  end
end
