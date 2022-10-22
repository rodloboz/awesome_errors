# frozen_string_literal: true

require "forwardable"

module AwesomeErrors
  class Errors
    include Enumerable

    extend Forwardable

    def_delegators :@errors, :each, :clear, :empty?, :size, :uniq!

    attr_reader :errors

    def initialize
      @errors = Set.new
    end

    def [](key)
      @errors.filter_map { |error| error.message if error.key == key }
    end

    def keys
      @errors.map(&:key).uniq.freeze
    end

    def add(key, **options)
      error = Error.new(key: key.to_sym, **options)
      @errors << error

      error
    end

    def merge!(other)
      other.errors.each do |error|
        import(error)
      end
    end

    def import(error)
      @errors << error
    end

    def as_json(options = {})
      to_hash(full_messages: options[:full_messages] || false)
    end

    def to_hash(full_messages: false)
      message_method = full_messages ? :full_message : :message
      group_by_key.transform_values do |err_objects|
        err_objects.map(&message_method)
      end
    end

    def group_by_key
      errors.group_by(&:key)
    end

    def messages
      hash = to_hash
      hash.default = [].freeze
      hash.freeze
      hash
    end

    def messages_for(key)
      @errors.filter_map { |error| error.message if error.key == key }
    end

    def full_messages
      errors.map(&:full_message)
    end
  end
end
