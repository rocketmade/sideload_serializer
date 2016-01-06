require "sideload_serializer/version"

module SideloadSerializer
end

require 'sideload_serializer/adapter' # Active Model Serializers registers the adapter on subclassing, so eagerload
