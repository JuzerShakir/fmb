module Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      const_defined?(:RANSACK_ATTRIBUTES) ? self::RANSACK_ATTRIBUTES : []
    end

    def ransackable_associations(auth_object = nil)
      const_defined?(:RANSACK_ASSOCIATIONS) ? self::RANSACK_ASSOCIATIONS : []
    end
  end
end
