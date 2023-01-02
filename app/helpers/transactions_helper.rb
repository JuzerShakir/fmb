module TransactionsHelper
  def readable_on_date(date)
   date.to_time.strftime('%A, %b %d %Y')
  end

  def time_ago_on_date(date)
    time_ago_in_words(date)
  end

  def amount_with_currency(amount)
    amount.to_s.prepend("₹")
  end
end
