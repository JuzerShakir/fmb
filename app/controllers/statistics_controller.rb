class StatisticsController < ApplicationController
  def thaalis
    authorize! :read, :thaalis
    years = Thaali.distinct.pluck(:year)
    @years = {}

    years.each do |y|
      thaalis = Thaali.for_year(y).preload(:transactions)
      @years[y] = {}
      @years[y].store(:total, thaalis.sum(:total))
      @years[y].store(:balance, thaalis.sum(&:balance))
      @years[y].store(:count, thaalis.count)
      @years[y].store(:pending, Thaali.dues_unpaid_for(y).length)
      @years[y].store(:complete, Thaali.dues_cleared_in(y).length)
      SIZES.each do |size|
        @years[y].store(size.to_sym, thaalis.send(size).count)
      end
    end
  end
end
