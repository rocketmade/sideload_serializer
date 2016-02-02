require 'active_model_serializers'
require 'camelize_keys'
module SideloadSerializer
  class CamelizedAttributesAdapter < ActiveModel::Serializer::Adapter::Attributes
    def self.deep_camelize_keys enumerable
      CamelizeKeys.camelize_keys enumerable, deep: true
    end

    def serializable_hash _options=nil
      super.tap do |document|
        self.class.deep_camelize_keys document if document.present?
      end
    end

    def meta
      super.tap do |document|
        self.class.deep_camelize_keys document if document.present?
      end
    end
  end
end
