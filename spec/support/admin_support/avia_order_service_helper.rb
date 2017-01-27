require 'support/admin_support/root_path_helper'
require 'support/root_path_helper'
require 'support/avia_test_data_helper'
require 'support/avia_booking_service_helper'
require 'support/admin_support/order_helper'

module AdminOrderService
  include AviaBookingService
  include OrderHelper

  def open_round_trip_order_in_admin
    search_round = DataRoundSearch.new
    if($round_trip_booking_regular.empty? || !order_available?($round_trip_booking_regular))
      # find in admin panel order
      visit($root_path_avia)
      # make search and open
      booking_round_trip(search_round)
      visit($root_path_admin_orders)
      find_order_in_admin($round_trip_booking_regular)
    end
  end

  def order_available?(order_name)
    unless(order_name.empty?)
      visit($root_path_admin_orders)
      find_order_in_admin(order_name)
      order_status = get_order_status
      #  order isnt available if it has been paid fully or have status
      order_paid_in_full? || order_status == 'ЗАВЕРШЕН' || order_status == 'ПРОСРОЧЕН' ||
          order_status == 'ОТМЕНЕН' ? false: true
    else
      false
    end
  end
end