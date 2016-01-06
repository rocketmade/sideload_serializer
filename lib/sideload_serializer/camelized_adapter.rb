require 'sideload_serializer/adapter'

module SideloadSerializer
  class CamelizedAdapter < Adapter
    def self.deep_camelize_keys enumerable
      if enumerable.is_a? Array
        enumerable.each do |item|
          deep_camelize_keys item if item.respond_to? :each
        end
      elsif
        enumerable.keys.each do |key|
          if key.is_a?(String) || key.is_a?(Symbol)
            new_key = key.to_s.camelize(:lower)
            new_key = new_key.to_sym if key.is_a? Symbol
            enumerable[new_key] = enumerable[key]
            enumerable.delete key

            if enumerable[new_key].respond_to? :each
              deep_camelize_keys enumerable[new_key]
            end
          end
        end
      end

      enumerable
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

      compiled_meta.merge(self.class.deep_camelize_keys(instance_options.fetch(:meta, Hash.new).deep_dup))
    end
  end
end
