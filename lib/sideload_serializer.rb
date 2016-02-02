require "sideload_serializer/version"

module SideloadSerializer
end

# Active Model Serializers registers the adapter on subclassing, so eagerload
require 'sideload_serializer/adapter'
require 'sideload_serializer/camelized_adapter'
require 'sideload_serializer/camelized_attributes_adapter'
require 'sideload_serializer/camelized_json_adapter'
