module HasFriendlyId
  extend ActiveSupport::Concern

  included do
    extend FriendlyId

    friendly_id :slug_candidates, use: [:slugged, :finders, :history]

    def slug_candidates
      sluggables.join("-")
    end

    def should_generate_new_friendly_id?
      sluggables.each { |attr| attribute_changed?(attr) }
    end
  end
end
