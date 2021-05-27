# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'dry-initializer'

module Realm
  class Config
    extend Dry::Initializer

    option :root_module
    option :database_url,         default: proc {}
    option :prefix,               default: proc {}
    option :namespace,            default: proc { root_module.to_s.underscore }
    option :domain_module,        default: proc { "#{root_module}::Domain" }
    option :engine_class,         default: proc { "#{root_module}::Engine" }
    option :engine_path,          default: proc { engine_class&.to_s&.safe_constantize&.root }
    option :logger,               default: proc {}
    option :dependencies,         default: proc { {} }
    option :job_scheduler,        default: proc { {} }
    option :persistence_gateway,  default: proc { database_url && { url: database_url } }
    option :event_gateway,        default: proc {}
    option :event_gateways,       default: proc {
      event_gateway ? { default: { **event_gateway, default: true } } : {}
    }
  end
end
