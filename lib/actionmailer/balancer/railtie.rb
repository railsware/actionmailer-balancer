# frozen_string_literal: true

module ActionMailer
  module Balancer
    class Railtie < Rails::Railtie
      initializer 'action_mailer_balancer.add_delivery_method', before: 'action_mailer.set_configs' do
        ActiveSupport.on_load(:action_mailer) do
          ::ActionMailer::Base.add_delivery_method(:balancer, ActionMailer::Balancer::DeliveryMethod)
        end
      end
    end
  end
end
