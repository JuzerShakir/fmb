module TransactionsHelper
  def readable_date(date)
    date.to_time.strftime("%A, %b %d %Y")
  end
end
