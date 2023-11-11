if defined?(CanCanCan)
  class Object
    def metaclass
      class << self; self; end
    end
  end

  module CanCan
    module ModelAdapters
      class ActiveRecordAdapter < AbstractAdapter
        @@friendly_support = {}

        def self.find(model_class, id)
          klass =
            model_class.metaclass.ancestors.include?(ActiveRecord::Associations::CollectionProxy) ?
              model_class.klass : model_class
          @@friendly_support[klass] ||= klass.metaclass.ancestors.include?(FriendlyId)
          (@@friendly_support[klass] == true) ? model_class.friendly.find(id) : model_class.find(id)
        end
      end
    end
  end
end
