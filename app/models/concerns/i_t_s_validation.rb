module ITSValidation
  extend ActiveSupport::Concern

  included do
    validates_numericality_of :its, only_integer: true, message: "must be a number"
    validates_numericality_of :its, in: 10000000..99999999, message: "is invalid"
    validates_uniqueness_of :its, message: "has already been registered"
  end
end
