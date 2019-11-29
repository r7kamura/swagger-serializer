require_relative "./serializer/version"
require_relative "./serializer/rails_controller"
require_relative "./serializer/model"
require_relative "./serializer/store"
require_relative "./schema"
require "yaml"

module Swagger
  module Serializer
    def self.included(klass)
      Store.current << klass

      def klass.inherited(klass)
        Store.current << klass
      end
    end

    def initialize(model)
      @model = model
    end

    def respond_to_missing?(name, include_private)
      if name == :"[]"
        false
      elsif @model.respond_to?(name)
        true
      else
        false
      end
    end

    def method_missing(name, *args)
      @model.public_send(name, *args)
    end
  end
end