# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem.tap do |loader|
  loader.ignore(
    "#{__dir__}/awesome_errors/version.rb"
  )
end.setup

module AwesomeErrors
  require_relative "awesome_errors/version"

  def self.included(base)
    base.include(InstanceMethods)
  end

  module InstanceMethods
    def errors
      @errors ||= AwesomeErrors::Errors.new
    end
  end
end
