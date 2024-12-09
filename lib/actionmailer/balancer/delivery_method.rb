# frozen_string_literal: true

module ActionMailer
  module Balancer
    class DeliveryMethod
      attr_reader :delivery_methods, :weights_sum

      def initialize(settings = {})
        add_delivery_methods(settings)
      end

      def deliver!(message)
        delivery_method = choose_delivery_method
        message.delivery_method(
          ::ActionMailer::Base.delivery_methods[delivery_method[:method]],
          delivery_method[:settings] || {}
        )
        message.deliver!
      end

      private

      def add_delivery_methods(settings)
        validate_settings!(settings)

        @delivery_methods = settings[:delivery_methods]
        @weights_sum = delivery_methods.sum do |method|
          unless method[:weight]
            raise ActionMailer::Balancer::SettingsError, "No weight set for delivery method #{method[:method]}"
          end

          method[:weight]
        end
      end

      def choose_delivery_method
        target = rand(1..weights_sum)
        delivery_methods.each do |method|
          return method if target <= method[:weight]

          target -= method[:weight]
        end
      end

      def validate_settings!(settings)
        raise ActionMailer::Balancer::SettingsError, 'No settings set' if settings.empty?

        return if settings[:delivery_methods].is_a?(Array) && !settings[:delivery_methods].empty?

        raise ActionMailer::Balancer::SettingsError, 'No delivery methods set'
      end
    end
  end
end
