module ITSValidation
  extend ActiveSupport::Concern

  included do
    validates :its, numericality: {only_integer: true}, length: {is: 8}, uniqueness: true
  end
end
