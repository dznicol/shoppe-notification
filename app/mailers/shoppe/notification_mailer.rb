module Shoppe
  class NotificationMailer < ActionMailer::Base
  
    def order_received(order)
      @order = order

      staff = get_staff_list

      mail from: Shoppe.settings.outbound_email_address, to: staff, subject: 'New Order Received' unless staff.empty?
    end

    def order_returned(order)
      @order = order

      staff = get_staff_list

      mail from: Shoppe.settings.outbound_email_address, to: staff, subject: 'Order Returned' unless staff.empty?
    end

    private
      def get_staff_list
        staff = []
        Shoppe::Retailer.joins(:countries).where(shoppe_countries: {id: order.delivery_country_id}).each do |retailer|
          staff << retailer.users.map(&:email_address)
        end
        staff = staff.flatten.uniq

        # Fallback on notifying all users not attached to any retailer (effectively superusers), or if asked to include them
        if Shoppe.settings.include_superusers.try(:downcase) == 'yes' || staff.empty?
          staff << Shoppe::User.includes(:retailers).where(shoppe_retailers: {id: nil}).map(&:email_address)
        end
        staff
      end
  end
end
