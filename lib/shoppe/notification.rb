require "shoppe/notification/version"
require "shoppe/notification/engine"

module Shoppe
  module Notification
    
    def self.setup
      # Set the configuration which we would like
      Shoppe.add_settings_group :notifications, [:include_superusers]

      Shoppe::Order.before_confirmation do
        Shoppe::NotificationMailer.order_received(self).deliver_now
      end

      Shoppe::Order.before_returning do
        Shoppe::NotificationMailer.order_returned(self).deliver_now
      end
    end

  end
end