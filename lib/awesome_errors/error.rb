# frozen_string_literal: true

module AwesomeErrors
  class Error
    attr_reader :key, :code, :message, :metadata

    def initialize(key:, code: :invalid, message: "is invalid", metadata: {})
      raise ArgumentError unless code.is_a?(Symbol) || code.is_a?(Integer)

      @key = key
      @code = code
      @message = message
      @metadata = metadata

      freeze
    end

    def full_message(include_key: true)
      if include_key
        [key, message].compact.join(" ")
      else
        message
      end
    end

    def to_hash(full_message: false)
      message_method = full_message ? :full_message : :message
      {
        key: key,
        code: code,
        message: public_send(message_method),
        metadata: metadata
      }
    end

    def ==(other)
      return false unless other.is_a?(AwesomeErrors::Error)

      to_hash == other.to_hash
    end

    def eql?(other)
      self == other
    end

    def hash
      to_hash.hash
    end
  end
end
