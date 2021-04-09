# frozen_string_literal: true

require 'realm/persistence'
require_relative 'read_only_relation_wrapper'

module Realm
  class Persistence
    module ROM
      class ReadOnlyRepositoryWrapper
        def initialize(repo)
          @repo = repo.clone
          @repo.define_singleton_method(:root) { ReadOnlyRelationWrapper.new(super()) }
        end

        def method_missing(name, *args, &block)
          @repo.send(name, *args, &block)
        rescue Persistence::RelationIsReadOnly
          raise Persistence::RepositoryIsReadOnly, @repo
        end

        def respond_to_missing?(*args)
          @repo.respond_to?(*args)
        end
      end
    end
  end
end
