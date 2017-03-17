module Shoppe
  class NotificationMailer < ActionMailer::Base
  
    def order_received(order)
      @order = order

      staff = []
      Shoppe::Retailer.joins(:countries).where(shoppe_countries: {id: order.delivery_country_id}).each do |retailer|
        staff << retailer.users.map(&:email_address)
      end
      staff = staff.flatten.uniq

      # Fallback on notifying all users not attached to any retailer (effectively superusers)
      staff = Shoppe::User.includes(:retailers).where(shoppe_retailers: {id: nil}).map(&:email_address) if staff.empty?

      mail from: Shoppe.settings.outbound_email_address, to: staff, subject: 'New Order Received' unless staff.empty?
    end
  end
end
