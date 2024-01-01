class StatisticsController < ApplicationController
  def sabeels
    authorize! :read, :thaalis

    @apts = {}

    Sabeel::APARTMENTS.each do |apartment|
      total_sabeels = Sabeel.send(apartment)
      active_thaalis = total_sabeels.taking_thaali
      inactive = total_sabeels.not_taking_thaali
      @apts[apartment] = {}
      @apts[apartment].store(:active_thaalis, active_thaalis.length)
      @apts[apartment].store(:total_sabeels, total_sabeels.length)
      @apts[apartment].store(:inactive_thaalis, inactive.length)
      SIZES.keys.each do |size|
        @apts[apartment].store(size.to_sym, active_thaalis.with_thaali_size(size).length)
      end
    end
  end

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
      SIZES.keys.each do |size|
        @years[y].store(size.to_sym, thaalis.send(size).count)
      end
    end
  end
end
