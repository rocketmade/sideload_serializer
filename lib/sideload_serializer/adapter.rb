require 'active_model_serializers'

module SideloadSerializer
  class Adapter < ActiveModel::Serializer::Adapter::Base
    def initialize(serializer, options = {})
      super
      @include_tree = ActiveModel::Serializer::IncludeTree.from_include_args(options[:include] || '*')
    end

    def serializable_hash _options=nil
      {}.tap do |document|
        add_serializer_to_document serializer, document, Hash.new, @include_tree
      end
    end

    def add_serializer_to_document serializer_instance, document, serialized_keys, include_tree
      return unless serializer_instance && serializer_instance.object
      if collection_serializer_given? serializer_instance
        serializer_instance.each do |s|
          add_serializer_to_document s, document, serialized_keys, include_tree
        end

      else
        cache_key = serializer_instance.object.cache_key rescue serializer_instance.object.hash

        return if serialized_keys.has_key? cache_key

        attributes = cache_check serializer_instance do
          serializer_instance.attributes
        end

        add_relationship_keys serializer_instance, attributes, include_tree

        key = root serializer_instance

        document[key] ||= []
        document[key] << attributes

        serialized_keys[cache_key] = true

        serializer_instance.associations(include_tree).each do |association|
          add_serializer_to_document association.serializer, document, serialized_keys, include_tree[association.key]
        end
      end

      document
    end

    def root serializer_instance=serializer
      serializer_instance.json_key.to_s.pluralize.to_sym
    end

    def meta
      compiled_meta = {
        primary_resource_collection: root
      }

      unless collection_serializer_given?
        compiled_meta[:primary_resource_id] = resource_identifier_id
      end

      compiled_meta.merge(instance_options.fetch(:meta, Hash.new))
    end

    protected

    def collection_serializer_given? serializer_instance=serializer
      serializer_instance.respond_to? :each
    end

    def embed_id_key_for association
      extension = '_id'
      extension += 's' if collection_serializer_given? association.serializer
      association_key = if association.options.has_key? :key
                          association.key
                        else
                          association.name.to_s.singularize
                        end

      :"#{association_key}#{extension}" # this is hokey, refactor. Can we interrogate the serializer/association for this information?
    end

    def embed_collection_key_for association
      association_key = if association.options.has_key? :key
                          association.key
                        else
                          association.name.to_s.singularize
                        end

      :"#{association_key}_collection"
    end

    def resource_identifier_id serializer_instance=serializer
      if serializer_instance.respond_to?(:id)
        serializer_instance.id
      else
        serializer_instance.object.id
      end
    end

    def add_relationship_keys serializer_instance, attributes, include_tree
      serializer_instance.associations(include_tree).each do |association|
        attributes[embed_id_key_for(association)] = relationship_id_value_for association
        attributes[embed_collection_key_for(association)] = if association.serializer
                                                              root association.serializer
                                                            else
                                                              nil
                                                            end
      end
    end

    def relationship_id_value_for association
      return association.options[:virtual_value] if association.options[:virtual_value]
      return unless association.serializer && association.serializer.object

      if collection_serializer_given? association.serializer
        association.serializer.map do |s|
          resource_identifier_id s
        end
      else
        resource_identifier_id association.serializer
      end
    end
  end
end
