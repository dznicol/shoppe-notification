module Shoppe
  class NotificationMailer < ActionMailer::Base
  
    def order_received(order)
      @order = order

      staff = []
      Shoppe::Retailer.joins(:countries).where(shoppe_countries: {id: order.delivery_country_id}).map(&:users).each do |users|
        staff << users.map(&:email_address)
      end
      staff = staff.uniq

      # Fallback on notifying all users
      staff = Shoppe::User.all.map(&:email_address) if staff.empty?

      mail from: Shoppe.settings.outbound_email_address, to: staff, subject: "New Order Received"
    end
  end
end
