class Numeric
  include ActionView::Helpers::NumberHelper

  def to_human(**kwargs)
    defaults = {precision: 1, round_mode: :down, significant: false, format: "%n%u", units: {thousand: "K", million: "M"}}
    number_to_human(self, defaults.merge(**kwargs))
  end
end
