# frozen_string_literal: true

require_relative 'balancer/delivery_method'
require_relative 'balancer/railtie' if defined? Rails
require_relative 'balancer/version'

module ActionMailer
  module Balancer
    class SettingsError < StandardError; end
  end
end
