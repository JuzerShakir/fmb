module NameValidation
  extend ActiveSupport::Concern

  included do
    validates :name, length: {in: 3..35}
  end
end
