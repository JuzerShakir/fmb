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
      Thaali::SIZES.each { @apts[apartment].store(_1, active_thaalis.with_thaali_size(_1).length) }
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
      Thaali::SIZES.each { @years[y].store(_1, thaalis.send(_1).count) }
    end
  end
end
