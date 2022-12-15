class Sabeel < ApplicationRecord
    validates :its, numericality: { only_integer: true } , length: { is: 8 }, uniqueness: true, presence: true
end
