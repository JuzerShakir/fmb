module NameCallback
  extend ActiveSupport::Concern

  included do
    before_save :capitalize_name, if: :will_save_change_to_name?
  end

  def capitalize_name
    self.name = name.split.map(&:capitalize).join(" ")
  end
end
