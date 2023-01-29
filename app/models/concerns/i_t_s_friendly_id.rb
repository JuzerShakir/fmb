module ITSFriendlyId
    extend ActiveSupport::Concern

    included do
        extend FriendlyId
        friendly_id :its, use: [:slugged, :finders, :history]

        def should_generate_new_friendly_id?
          its_changed?
        end
    end
end