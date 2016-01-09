require 'sideload_serializer/adapter'
require 'camelize_keys'
module SideloadSerializer
  class CamelizedAdapter < Adapter
    def self.deep_camelize_keys enumerable
      CamelizeKeys.camelize_keys enumerable, deep: true
    end

    def serializable_hash _options=nil
      super.tap do |document|
        self.class.deep_camelize_keys document
      end
    end

    def meta
      compiled_meta = {
        primaryResourceCollection: root.to_s.camelize(:lower)
      }

      unless collection_serializer_given?
        compiled_meta[:primaryResourceId] = resource_identifier_id
      end

      compiled_meta.merge!(self.class.deep_camelize_keys(instance_options.fetch(:meta, Hash.new).deep_dup))

      compiled_meta
    end
  end
end
