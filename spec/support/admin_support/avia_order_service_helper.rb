require 'support/admin_support/root_path_helper'
require 'support/root_path_helper'
require 'support/avia_test_data_helper'
require 'support/avia_booking_service_helper'
require 'support/admin_support/order_helper'

module AdminOrderService
  include AviaBookingService
  include OrderHelper

  def open_round_trip_order_in_admin
    unless($round_trip_booking_regular.empty?)
      # find in admin panel order
      visit($root_path_admin_orders)
      find_order_in_admin($round_trip_booking_regular)
    else
      visit($root_path_avia)
      # make search and open
      search_round = DataRoundSearch.new
      booking_round_trip(search_round)
      visit($root_path_admin_orders)
      find_order_in_admin($round_trip_booking_regular)
    end
  end
end